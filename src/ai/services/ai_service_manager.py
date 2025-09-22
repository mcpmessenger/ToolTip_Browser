"""
AI Service Manager - Central coordinator for all AI services
Handles routing, fallback, and unified response processing
"""

import asyncio
import logging
from typing import Dict, List, Optional, Any, Union
from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum

from .openai_adapter import OpenAIAdapter
from .gemini_adapter import GeminiAdapter
from .anthropic_adapter import AnthropicAdapter

class AIModel(Enum):
    OPENAI_GPT4 = "openai_gpt4"
    OPENAI_GPT35 = "openai_gpt35"
    GEMINI_PRO = "gemini_pro"
    GEMINI_PRO_VISION = "gemini_pro_vision"
    CLAUDE_OPUS = "claude_opus"
    CLAUDE_SONNET = "claude_sonnet"
    CLAUDE_HAIKU = "claude_haiku"

@dataclass
class AIResponse:
    content: str
    model_used: AIModel
    tokens_used: Optional[int] = None
    processing_time: Optional[float] = None
    error: Optional[str] = None

class AIServiceManager:
    """Central manager for all AI services with fallback and load balancing"""
    
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.logger = logging.getLogger(__name__)
        
        # Initialize adapters
        self.adapters = {
            AIModel.OPENAI_GPT4: OpenAIAdapter(config.get('openai', {}), model='gpt-4'),
            AIModel.OPENAI_GPT35: OpenAIAdapter(config.get('openai', {}), model='gpt-3.5-turbo'),
            AIModel.GEMINI_PRO: GeminiAdapter(config.get('gemini', {}), model='gemini-pro'),
            AIModel.GEMINI_PRO_VISION: GeminiAdapter(config.get('gemini', {}), model='gemini-pro-vision'),
            AIModel.CLAUDE_OPUS: AnthropicAdapter(config.get('anthropic', {}), model='claude-3-opus-20240229'),
            AIModel.CLAUDE_SONNET: AnthropicAdapter(config.get('anthropic', {}), model='claude-3-sonnet-20240229'),
            AIModel.CLAUDE_HAIKU: AnthropicAdapter(config.get('anthropic', {}), model='claude-3-haiku-20240307'),
        }
        
        # Model preferences and fallback chains
        self.model_preferences = config.get('model_preferences', {
            'primary': AIModel.OPENAI_GPT4,
            'fallback_chain': [
                AIModel.OPENAI_GPT35,
                AIModel.CLAUDE_SONNET,
                AIModel.GEMINI_PRO
            ]
        })
        
        # Rate limiting and request queuing
        self.request_queues = {model: asyncio.Queue() for model in AIModel}
        self.rate_limits = self._initialize_rate_limits()
        
    def _initialize_rate_limits(self) -> Dict[AIModel, Dict[str, Any]]:
        """Initialize rate limiting configuration for each model"""
        return {
            AIModel.OPENAI_GPT4: {'requests_per_minute': 10000, 'tokens_per_minute': 150000},
            AIModel.OPENAI_GPT35: {'requests_per_minute': 3500, 'tokens_per_minute': 90000},
            AIModel.GEMINI_PRO: {'requests_per_minute': 1500, 'tokens_per_minute': 32000},
            AIModel.GEMINI_PRO_VISION: {'requests_per_minute': 1500, 'tokens_per_minute': 32000},
            AIModel.CLAUDE_OPUS: {'requests_per_minute': 1000, 'tokens_per_minute': 40000},
            AIModel.CLAUDE_SONNET: {'requests_per_minute': 1000, 'tokens_per_minute': 40000},
            AIModel.CLAUDE_HAIKU: {'requests_per_minute': 1000, 'tokens_per_minute': 40000},
        }
    
    async def process_request(
        self,
        prompt: str,
        model: Optional[AIModel] = None,
        context: Optional[Dict[str, Any]] = None,
        images: Optional[List[str]] = None,
        max_retries: int = 3
    ) -> AIResponse:
        """
        Process a request using the specified model or fallback chain
        
        Args:
            prompt: The input prompt
            model: Specific model to use (uses primary if None)
            context: Additional context for the request
            images: List of image paths for vision models
            max_retries: Maximum number of retry attempts
            
        Returns:
            AIResponse object with the result
        """
        if model is None:
            model = self.model_preferences['primary']
        
        # Determine which models to try
        models_to_try = [model] + self.model_preferences['fallback_chain']
        models_to_try = [m for m in models_to_try if m != model]  # Remove duplicates
        
        last_error = None
        
        for attempt, current_model in enumerate(models_to_try):
            try:
                if current_model not in self.adapters:
                    self.logger.warning(f"Model {current_model} not available, skipping")
                    continue
                
                # Check if model supports images
                if images and not self._supports_images(current_model):
                    self.logger.warning(f"Model {current_model} doesn't support images, skipping")
                    continue
                
                # Process the request
                response = await self._process_with_model(
                    current_model, prompt, context, images
                )
                
                if response.error:
                    last_error = response.error
                    self.logger.warning(f"Model {current_model} failed: {response.error}")
                    continue
                
                self.logger.info(f"Successfully processed request with {current_model}")
                return response
                
            except Exception as e:
                last_error = str(e)
                self.logger.error(f"Error with model {current_model}: {e}")
                continue
        
        # All models failed
        return AIResponse(
            content="",
            model_used=model,
            error=f"All models failed. Last error: {last_error}"
        )
    
    async def _process_with_model(
        self,
        model: AIModel,
        prompt: str,
        context: Optional[Dict[str, Any]],
        images: Optional[List[str]]
    ) -> AIResponse:
        """Process request with a specific model"""
        adapter = self.adapters[model]
        
        # Add context to prompt if provided
        if context:
            context_str = self._format_context(context)
            prompt = f"{context_str}\n\n{prompt}"
        
        # Process based on model capabilities
        if images and self._supports_images(model):
            return await adapter.process_with_images(prompt, images)
        else:
            return await adapter.process_text(prompt)
    
    def _supports_images(self, model: AIModel) -> bool:
        """Check if model supports image processing"""
        vision_models = {
            AIModel.GEMINI_PRO_VISION,
            AIModel.OPENAI_GPT4,  # GPT-4 with vision
            AIModel.CLAUDE_OPUS,  # Claude with vision
            AIModel.CLAUDE_SONNET,
            AIModel.CLAUDE_HAIKU
        }
        return model in vision_models
    
    def _format_context(self, context: Dict[str, Any]) -> str:
        """Format context dictionary into a readable string"""
        context_parts = []
        
        if 'page_title' in context:
            context_parts.append(f"Page Title: {context['page_title']}")
        
        if 'page_url' in context:
            context_parts.append(f"URL: {context['page_url']}")
        
        if 'page_content' in context:
            # Truncate long content
            content = context['page_content']
            if len(content) > 2000:
                content = content[:2000] + "..."
            context_parts.append(f"Page Content: {content}")
        
        if 'user_intent' in context:
            context_parts.append(f"User Intent: {context['user_intent']}")
        
        return "\n".join(context_parts)
    
    async def get_available_models(self) -> List[AIModel]:
        """Get list of available models based on API key configuration"""
        available = []
        
        for model, adapter in self.adapters.items():
            if await adapter.is_available():
                available.append(model)
        
        return available
    
    async def get_model_info(self, model: AIModel) -> Dict[str, Any]:
        """Get information about a specific model"""
        if model not in self.adapters:
            return {'available': False, 'error': 'Model not found'}
        
        adapter = self.adapters[model]
        return await adapter.get_model_info()
    
    def update_config(self, new_config: Dict[str, Any]):
        """Update configuration and reinitialize adapters"""
        self.config.update(new_config)
        
        # Reinitialize adapters with new config
        for model, adapter in self.adapters.items():
            adapter.update_config(self.config.get(adapter.provider_name, {}))
    
    async def health_check(self) -> Dict[str, Any]:
        """Perform health check on all available models"""
        health_status = {}
        
        for model, adapter in self.adapters.items():
            try:
                is_available = await adapter.is_available()
                health_status[model.value] = {
                    'available': is_available,
                    'last_check': asyncio.get_event_loop().time()
                }
            except Exception as e:
                health_status[model.value] = {
                    'available': False,
                    'error': str(e),
                    'last_check': asyncio.get_event_loop().time()
                }
        
        return health_status
