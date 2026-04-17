import '../domain/entities/article.dart';
import '../domain/entities/content_block.dart';

/// Sample articles displayed in the portfolio.
/// Replace or extend these with your own articles.
final List<Article> sampleArticles = [_rlArticle, _rainfallArticle, _cvArticle];

// ---------------------------------------------------------------------------
// Article 1 — Reinforcement Learning (plain markdown)
// ---------------------------------------------------------------------------
const _rlArticle = Article(
  id: 'reinforcement-learning-agriculture',
  title: 'Reinforcement Learning for Smarter Agricultural Decisions',
  description:
      'How RL agents can learn optimal irrigation, fertilization, and planting strategies by interacting with simulated farm environments.',
  date: '2026-03-28',
  author: 'Ayiko Andrew',
  tags: ['Reinforcement Learning', 'AgriTech', 'AI'],
  readTimeMinutes: 8,
  content: '''# Reinforcement Learning for Smarter Agricultural Decisions

Agriculture is one of the oldest human endeavors, yet it remains one of the most challenging optimization problems. Every season, farmers make hundreds of sequential decisions — when to plant, how much to irrigate, when to apply fertilizer — each of which affects future outcomes in complex, interdependent ways.

## Why Reinforcement Learning?

Traditional rule-based systems and even supervised learning approaches fall short here. They can predict outcomes but they can't learn *strategies*. Reinforcement Learning (RL) is fundamentally different: it learns optimal **policies** by interacting with an environment over time.

```python
import gymnasium as gym
import numpy as np

class FarmEnv(gym.Env):
    """A simplified farm environment for RL."""
    
    def __init__(self):
        super().__init__()
        # Actions: [no_action, irrigate, fertilize, harvest]
        self.action_space = gym.spaces.Discrete(4)
        # State: [soil_moisture, crop_growth, days_since_planting, rainfall]
        self.observation_space = gym.spaces.Box(
            low=0, high=1, shape=(4,), dtype=np.float32
        )
        self.reset()
    
    def step(self, action):
        # Apply action effects to state
        reward = self._calculate_reward(action)
        self.state = self._transition(action)
        done = self.state[2] >= 1.0  # Season ended
        return self.state, reward, done, False, {}
    
    def reset(self, seed=None):
        super().reset(seed=seed)
        self.state = np.array([0.5, 0.0, 0.0, 0.3])
        return self.state, {}
```

The code above sketches a simplified farm environment. The agent observes soil moisture, crop growth stage, time elapsed, and rainfall — then chooses an action each day.

## The Markov Decision Process

We model the farm as a Markov Decision Process (MDP) where:

- **States** capture soil conditions, weather, and crop status
- **Actions** represent farming interventions
- **Rewards** reflect crop yield minus resource costs
- **Transitions** are governed by agronomic models

The key insight is that today's irrigation decision affects tomorrow's soil moisture, which affects next week's crop health. RL handles this temporal dependency naturally.

## Proximal Policy Optimization in Practice

We use PPO (Proximal Policy Optimization) for training because it offers a good balance between sample efficiency and stability:

```python
from stable_baselines3 import PPO

model = PPO(
    "MlpPolicy",
    env,
    learning_rate=3e-4,
    n_steps=2048,
    batch_size=64,
    verbose=1,
)
model.learn(total_timesteps=500_000)
```

After 500,000 timesteps of simulated farming, our agent learns to:

1. Irrigate *before* predicted dry spells rather than reacting to wilting
2. Apply fertilizer during peak growth phases for maximum uptake
3. Time harvests to balance ripeness against weather risk

## Results and Implications

In simulation, the RL agent achieved 23% higher yield compared to rule-based heuristics, while using 15% less water. These results are preliminary but suggest that RL could meaningfully improve resource efficiency in real farming operations.

The next step is validating these policies against historical farm data from Uganda's agricultural regions, where variable rainfall makes optimal decision-making especially critical.

## What's Next

I'm currently extending this work to incorporate real weather forecast data and multi-crop scenarios. The goal is a decision support tool that gives smallholder farmers actionable, personalized recommendations — not just predictions, but actual strategies.''',
);

// ---------------------------------------------------------------------------
// Article 2 — Rainfall Prediction (rich content blocks)
// ---------------------------------------------------------------------------
const _rainfallArticle = Article(
  id: 'rainfall-prediction-deep-learning',
  title: 'Predicting Rainfall with Deep Learning: Lessons from East Africa',
  description:
      'An exploration of LSTM and Transformer architectures for rainfall forecasting in data-scarce regions of East Africa.',
  date: '2026-02-15',
  author: 'Ayiko Andrew',
  tags: ['Deep Learning', 'Climate', 'Time Series'],
  readTimeMinutes: 10,
  content: '',
  contentBlocks: [
    ContentBlock(
      type: 'text',
      text:
          '# Predicting Rainfall with Deep Learning: Lessons from East Africa\n\n'
          'Accurate rainfall prediction is arguably the single most impactful AI application for East African agriculture. '
          'Millions of smallholder farmers depend on rain-fed agriculture, and a missed forecast can mean the difference between food security and crop failure.',
    ),
    ContentBlock(
      type: 'image',
      src: 'https://picsum.photos/seed/rainfall/800/400',
      caption:
          'Satellite-derived rainfall distribution across East Africa showing the bimodal rainfall pattern characteristic of equatorial regions.',
    ),
    ContentBlock(
      type: 'text',
      text: '''## The Data Challenge

Unlike developed regions with dense weather station networks, East Africa has sparse, unevenly distributed ground stations. Satellite-derived rainfall estimates (like CHIRPS and TAMSAT) help fill gaps, but they introduce their own biases and uncertainties.

Our dataset combines:

- **Ground station data** from Uganda's national meteorological authority (42 stations)
- **CHIRPS satellite estimates** at 0.05° resolution (1981–2025)
- **ERA5 reanalysis** for atmospheric variables (temperature, humidity, wind)

```python
import xarray as xr
import pandas as pd

# Load and merge heterogeneous data sources
chirps = xr.open_dataset('chirps_east_africa.nc')
stations = pd.read_csv('uganda_stations.csv', parse_dates=['date'])
era5 = xr.open_dataset('era5_atmospheric.nc')

# Align temporal resolution to dekadal (10-day) periods
chirps_dekadal = chirps.resample(time='10D').sum()
era5_dekadal = era5.resample(time='10D').mean()
```''',
    ),
    ContentBlock(
      type: 'text',
      text: '''## Architecture: Temporal Fusion Transformer

We chose the Temporal Fusion Transformer (TFT) over simpler LSTM approaches for several reasons:

1. **Multi-horizon forecasting** — predicts 1 to 6 dekads ahead simultaneously
2. **Variable selection** — automatically identifies which inputs matter for each time step
3. **Interpretability** — attention weights reveal which past periods influence the forecast

```python
import pytorch_lightning as pl
from pytorch_forecasting import TemporalFusionTransformer

tft = TemporalFusionTransformer.from_dataset(
    training_dataset,
    hidden_size=64,
    attention_head_size=4,
    dropout=0.1,
    hidden_continuous_size=32,
    loss=QuantileLoss(),
    learning_rate=1e-3,
)

trainer = pl.Trainer(max_epochs=100, gradient_clip_val=0.5)
trainer.fit(tft, train_dataloaders=train_dl, val_dataloaders=val_dl)
```

## Handling Seasonality

East African rainfall is bimodal — two rainy seasons (MAM and OND) separated by dry periods. This strong seasonality can dominate predictions and mask the model's ability to capture inter-annual variability.

We address this through:

- Seasonal decomposition as a preprocessing step
- Cyclic time features (sin/cos encoding of day-of-year)
- Separate evaluation metrics for onset, cessation, and total seasonal rainfall''',
    ),
    ContentBlock(
      type: 'chart',
      chartType: 'line',
      chartTitle: 'Monthly Rainfall Trends — Observed vs. Predicted (mm)',
      labels: [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ],
      datasets: [
        ChartDataSet(
          label: 'Observed',
          data: [46, 62, 130, 175, 118, 35, 28, 52, 85, 155, 140, 68],
          color: '#3B82F6',
        ),
        ChartDataSet(
          label: 'TFT Predicted',
          data: [50, 58, 122, 168, 125, 40, 32, 48, 80, 148, 135, 72],
          color: '#06B6D4',
        ),
        ChartDataSet(
          label: 'LSTM Predicted',
          data: [55, 70, 110, 155, 130, 50, 42, 60, 74, 138, 125, 78],
          color: '#10B981',
        ),
      ],
    ),
    ContentBlock(
      type: 'chart',
      chartType: 'bar',
      chartTitle: 'Model Performance Comparison — Error Metrics',
      labels: ['MAE (mm)', 'Onset Accuracy %', 'Dry Spell Accuracy %'],
      datasets: [
        ChartDataSet(
          label: 'Climatology Baseline',
          data: [18.4, 52, 44],
          color: '#94A3B8',
        ),
        ChartDataSet(label: 'LSTM', data: [14.2, 71, 65], color: '#3B82F6'),
        ChartDataSet(
          label: 'TFT (Ours)',
          data: [11.8, 83, 78],
          color: '#06B6D4',
        ),
      ],
    ),
    ContentBlock(
      type: 'text',
      text: '''## Key Results

The TFT model reduces mean absolute error by **36%** compared to climatological baselines and, critically, achieves **83% accuracy** in predicting the onset of rainy seasons within one dekad.

## Practical Impact

Rainfall onset prediction is arguably more valuable than total rainfall prediction for farmers. Knowing *when* the rains will start determines planting dates, and planting too early (before consistent rains) or too late (missing the optimal growth window) can devastate yields.

We're packaging these predictions into a decision support system that will provide location-specific planting advisories for farmers in central and eastern Uganda.

## Lessons Learned

1. **Data quality trumps model complexity.** Cleaning and validating station data improved all models more than architectural changes.
2. **Spatial context matters.** Including neighboring grid cells' data improved predictions by ~8%, suggesting moisture transport effects.
3. **Evaluation must be task-specific.** Low MAE doesn't guarantee good onset prediction. Always evaluate against the end-user's actual decision problem.''',
    ),
  ],
);

// ---------------------------------------------------------------------------
// Article 3 — Computer Vision & Drones (rich content blocks)
// ---------------------------------------------------------------------------
const _cvArticle = Article(
  id: 'computer-vision-crop-monitoring',
  title: 'Crop Health Monitoring with Computer Vision and Drones',
  description:
      'Using convolutional neural networks on drone imagery to detect early signs of crop disease and nutrient deficiency.',
  date: '2026-01-10',
  author: 'Ayiko Andrew',
  tags: ['Computer Vision', 'AgriTech', 'Deep Learning'],
  readTimeMinutes: 7,
  content: '',
  contentBlocks: [
    ContentBlock(
      type: 'text',
      text: '''# Crop Health Monitoring with Computer Vision and Drones

Traditional crop scouting — walking through fields to inspect plants — is time-consuming, subjective, and limited in scale. Drone-based imaging combined with computer vision offers a scalable alternative that can detect problems before they're visible to the naked eye.

## The Imaging Pipeline

Our pipeline captures multispectral drone imagery at 3cm/pixel resolution, processes it into orthomosaics, and feeds individual plot images into a classification model.

```python
import torch
import torchvision.transforms as T
from torchvision.models import efficientnet_v2_s

# Custom model for 5-band multispectral input
class CropHealthClassifier(torch.nn.Module):
    def __init__(self, num_classes=5):
        super().__init__()
        self.backbone = efficientnet_v2_s(weights=None)
        # Modify first conv to accept 5 channels (RGB + NIR + RedEdge)
        self.backbone.features[0][0] = torch.nn.Conv2d(
            5, 24, kernel_size=3, stride=2, padding=1, bias=False
        )
        self.backbone.classifier[1] = torch.nn.Linear(1280, num_classes)
    
    def forward(self, x):
        return self.backbone(x)

model = CropHealthClassifier(num_classes=5)
```

The five classes we detect are:

1. **Healthy** — normal growth
2. **Nitrogen deficiency** — yellowing leaves, stunted growth
3. **Water stress** — wilting, leaf curling
4. **Fungal disease** — spots, lesions
5. **Pest damage** — holes, irregular patterns''',
    ),
    ContentBlock(
      type: 'image',
      src: 'https://picsum.photos/seed/dronemosaic/800/400',
      caption:
          'Drone-captured multispectral orthomosaic of a maize field with overlaid NDVI health classification map.',
    ),
    ContentBlock(
      type: 'text',
      text: '''## Why Multispectral?

RGB cameras capture what humans see, but plant stress often manifests first in wavelengths we can't perceive. The Normalized Difference Vegetation Index (NDVI) derived from near-infrared (NIR) and red bands is a classic indicator:

```python
def compute_ndvi(nir_band, red_band):
    """NDVI = (NIR - Red) / (NIR + Red)"""
    ndvi = (nir_band - red_band) / (nir_band + red_band + 1e-8)
    return ndvi
```

NDVI drops before visible symptoms appear, giving farmers a crucial early warning window of 5–10 days.''',
    ),
    ContentBlock(
      type: 'chart',
      chartType: 'bar',
      chartTitle: 'Classification Accuracy by Training Strategy',
      labels: ['From Scratch', 'ImageNet Pretrained', 'DINO + Active Learning'],
      datasets: [
        ChartDataSet(
          label: 'Accuracy (%)',
          data: [78, 85, 91],
          color: '#3B82F6',
        ),
      ],
    ),
    ContentBlock(
      type: 'text',
      text: '''## Training with Limited Labels

Labeled agricultural imagery is scarce. We addressed this through:

- **Self-supervised pre-training** on 50,000 unlabeled drone images using DINO
- **Active learning** to prioritize labeling the most informative samples
- **Augmentation** tuned for aerial imagery (rotation, scale, atmospheric noise)

With just 2,000 labeled images, our model achieves 91% classification accuracy — compared to 78% for a model trained from scratch.

## Field Deployment

The model runs on a lightweight edge device (NVIDIA Jetson) mounted on the drone's ground station laptop. Processing a 10-hectare field takes approximately 4 minutes after landing, and results are displayed as a color-coded health map.

Farmers and agronomists can then focus their physical scouting on flagged areas, reducing inspection time by roughly 70% while improving detection rates.

## Looking Ahead

The next phase integrates temporal sequences — comparing images of the same plots over weeks to detect deterioration trends rather than single-frame classification. This temporal approach should catch slow-onset problems like nutrient depletion that single snapshots miss.''',
    ),
  ],
);
