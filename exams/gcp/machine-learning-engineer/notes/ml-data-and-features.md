# ML Data and Features - GCP Professional Machine Learning Engineer

## Overview

Comprehensive guide to data preparation, feature engineering, TensorFlow Transform, Vertex AI Feature Store, data validation, and ML data pipelines for the Professional Machine Learning Engineer exam.

**Exam Weight**: Data preparation and feature engineering account for approximately 25-30% of the exam questions.

**Key Topics**:
- Data profiling, cleaning, and preparation
- Feature engineering and transformation techniques
- TensorFlow Transform (TFT) for preprocessing
- Vertex AI Feature Store architecture and usage
- TensorFlow Data Validation (TFDV)
- BigQuery ML feature engineering
- Data pipeline design patterns
- Feature monitoring and drift detection

## Data Preparation

### Data Collection and Sources

**GCP Data Sources**:
- **BigQuery**: Petabyte-scale analytics, structured data
- **Cloud Storage**: Object storage (CSV, JSON, Parquet, Avro, TFRecord)
- **Pub/Sub**: Real-time streaming data ingestion
- **Cloud SQL/Spanner**: Relational databases
- **Bigtable**: NoSQL for time-series and high-throughput workloads
- **Firestore**: Document database
- **External APIs**: RESTful services, partner data

```python
# Read from multiple GCP sources
from google.cloud import bigquery, storage
import pandas as pd
import tensorflow as tf

# BigQuery
client = bigquery.Client()
query = """
    SELECT *
    FROM `project.dataset.table`
    WHERE date >= '2024-01-01'
"""
df_bq = client.query(query).to_dataframe()

# Cloud Storage - CSV
storage_client = storage.Client()
bucket = storage_client.bucket('my-bucket')
blob = bucket.blob('data/train.csv')
df_gcs = pd.read_csv(f'gs://my-bucket/data/train.csv')

# Cloud Storage - Parquet (more efficient)
df_parquet = pd.read_parquet('gs://my-bucket/data/train.parquet')

# TFRecord for TensorFlow models
def parse_tfrecord(example_proto):
    feature_description = {
        'feature1': tf.io.FixedLenFeature([], tf.float32),
        'feature2': tf.io.FixedLenFeature([], tf.int64),
        'label': tf.io.FixedLenFeature([], tf.int64),
    }
    return tf.io.parse_single_example(example_proto, feature_description)

dataset = tf.data.TFRecordDataset('gs://bucket/data.tfrecord')
dataset = dataset.map(parse_tfrecord)

# Pub/Sub streaming
from google.cloud import pubsub_v1

subscriber = pubsub_v1.SubscriberClient()
subscription_path = subscriber.subscription_path(project_id, subscription_id)

def callback(message):
    data = json.loads(message.data.decode('utf-8'))
    # Process streaming data
    message.ack()

streaming_pull_future = subscriber.subscribe(subscription_path, callback=callback)
```

### Data Profiling

**Understanding Your Data**:

```python
import pandas as pd
import numpy as np
from scipy import stats

def comprehensive_data_profile(df):
    """Generate comprehensive data profile"""

    profile = {
        'shape': df.shape,
        'memory_usage': df.memory_usage(deep=True).sum() / 1024**2,  # MB
        'missing_values': df.isnull().sum(),
        'missing_percentage': (df.isnull().sum() / len(df)) * 100,
        'duplicate_rows': df.duplicated().sum(),
        'numeric_summary': df.describe(),
        'categorical_summary': {}
    }

    # Numeric features
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    for col in numeric_cols:
        profile[col] = {
            'mean': df[col].mean(),
            'median': df[col].median(),
            'std': df[col].std(),
            'min': df[col].min(),
            'max': df[col].max(),
            'skewness': stats.skew(df[col].dropna()),
            'kurtosis': stats.kurtosis(df[col].dropna()),
            'outliers_iqr': detect_outliers_iqr(df[col]),
            'zeros': (df[col] == 0).sum(),
            'unique_values': df[col].nunique()
        }

    # Categorical features
    categorical_cols = df.select_dtypes(include=['object', 'category']).columns
    for col in categorical_cols:
        profile['categorical_summary'][col] = {
            'unique_values': df[col].nunique(),
            'top_values': df[col].value_counts().head(10).to_dict(),
            'mode': df[col].mode()[0] if len(df[col].mode()) > 0 else None,
            'cardinality': df[col].nunique() / len(df)
        }

    return profile

def detect_outliers_iqr(series):
    """Detect outliers using IQR method"""
    Q1 = series.quantile(0.25)
    Q3 = series.quantile(0.75)
    IQR = Q3 - Q1
    lower_bound = Q1 - 1.5 * IQR
    upper_bound = Q3 + 1.5 * IQR
    outliers = ((series < lower_bound) | (series > upper_bound)).sum()
    return outliers

# Use pandas-profiling for automated EDA
from pandas_profiling import ProfileReport

profile = ProfileReport(df, title='Data Profiling Report', explorative=True)
profile.to_file('data_profile.html')
```

### Data Cleaning

**Handling Missing Values**:

```python
import pandas as pd
import numpy as np
from sklearn.impute import SimpleImputer, KNNImputer
from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer

class DataCleaner:
    """Comprehensive data cleaning pipeline"""

    def __init__(self, df):
        self.df = df.copy()
        self.cleaning_log = []

    def remove_duplicates(self):
        """Remove duplicate rows"""
        initial_rows = len(self.df)
        self.df.drop_duplicates(inplace=True)
        removed = initial_rows - len(self.df)
        self.cleaning_log.append(f"Removed {removed} duplicate rows")
        return self

    def handle_missing_numeric(self, strategy='mean', columns=None):
        """
        Handle missing numeric values
        Strategies: 'mean', 'median', 'mode', 'constant', 'knn', 'iterative'
        """
        if columns is None:
            columns = self.df.select_dtypes(include=[np.number]).columns

        if strategy in ['mean', 'median', 'most_frequent', 'constant']:
            imputer = SimpleImputer(strategy=strategy)
            self.df[columns] = imputer.fit_transform(self.df[columns])

        elif strategy == 'knn':
            imputer = KNNImputer(n_neighbors=5)
            self.df[columns] = imputer.fit_transform(self.df[columns])

        elif strategy == 'iterative':
            imputer = IterativeImputer(random_state=42)
            self.df[columns] = imputer.fit_transform(self.df[columns])

        self.cleaning_log.append(f"Imputed missing numeric values using {strategy}")
        return self

    def handle_missing_categorical(self, strategy='mode', columns=None):
        """Handle missing categorical values"""
        if columns is None:
            columns = self.df.select_dtypes(include=['object', 'category']).columns

        for col in columns:
            if strategy == 'mode':
                mode_value = self.df[col].mode()[0] if len(self.df[col].mode()) > 0 else 'UNKNOWN'
                self.df[col].fillna(mode_value, inplace=True)
            elif strategy == 'constant':
                self.df[col].fillna('MISSING', inplace=True)

        self.cleaning_log.append(f"Imputed missing categorical values using {strategy}")
        return self

    def remove_outliers(self, columns, method='iqr', threshold=1.5):
        """Remove outliers from numeric columns"""
        initial_rows = len(self.df)

        for col in columns:
            if method == 'iqr':
                Q1 = self.df[col].quantile(0.25)
                Q3 = self.df[col].quantile(0.75)
                IQR = Q3 - Q1
                lower = Q1 - threshold * IQR
                upper = Q3 + threshold * IQR
                self.df = self.df[(self.df[col] >= lower) & (self.df[col] <= upper)]

            elif method == 'zscore':
                z_scores = np.abs(stats.zscore(self.df[col]))
                self.df = self.df[z_scores < threshold]

        removed = initial_rows - len(self.df)
        self.cleaning_log.append(f"Removed {removed} outlier rows")
        return self

    def cap_outliers(self, columns, lower_percentile=1, upper_percentile=99):
        """Cap outliers instead of removing them"""
        for col in columns:
            lower = self.df[col].quantile(lower_percentile / 100)
            upper = self.df[col].quantile(upper_percentile / 100)
            self.df[col] = self.df[col].clip(lower, upper)

        self.cleaning_log.append(f"Capped outliers for {len(columns)} columns")
        return self

    def handle_data_types(self, type_mapping):
        """Convert data types"""
        for col, dtype in type_mapping.items():
            self.df[col] = self.df[col].astype(dtype)

        self.cleaning_log.append(f"Converted {len(type_mapping)} column types")
        return self

    def get_cleaned_data(self):
        """Return cleaned dataframe and log"""
        return self.df, self.cleaning_log

# Example usage
cleaner = DataCleaner(df)
cleaned_df, log = (cleaner
    .remove_duplicates()
    .handle_missing_numeric(strategy='knn')
    .handle_missing_categorical(strategy='mode')
    .cap_outliers(['age', 'income'], lower_percentile=1, upper_percentile=99)
    .get_cleaned_data())

print('\n'.join(log))
```

### Data Sampling Strategies

```python
import pandas as pd
from sklearn.model_selection import train_test_split
from imblearn.over_sampling import SMOTE, ADASYN
from imblearn.under_sampling import RandomUnderSampler, TomekLinks
from imblearn.combine import SMOTETomek

class DataSampler:
    """Various sampling strategies for ML"""

    @staticmethod
    def random_sampling(df, n_samples=1000, random_state=42):
        """Simple random sampling"""
        return df.sample(n=n_samples, random_state=random_state)

    @staticmethod
    def stratified_sampling(df, target_col, test_size=0.2, random_state=42):
        """Stratified sampling maintaining class distribution"""
        X = df.drop(columns=[target_col])
        y = df[target_col]

        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=test_size, stratify=y, random_state=random_state
        )

        train = pd.concat([X_train, y_train], axis=1)
        test = pd.concat([X_test, y_test], axis=1)

        return train, test

    @staticmethod
    def time_based_split(df, date_col, train_end_date, val_end_date):
        """Time-based split for time series data"""
        df = df.sort_values(date_col)

        train = df[df[date_col] <= train_end_date]
        val = df[(df[date_col] > train_end_date) & (df[date_col] <= val_end_date)]
        test = df[df[date_col] > val_end_date]

        return train, val, test

    @staticmethod
    def reservoir_sampling(stream, k):
        """Reservoir sampling for streaming data"""
        reservoir = []

        for i, item in enumerate(stream):
            if i < k:
                reservoir.append(item)
            else:
                j = np.random.randint(0, i + 1)
                if j < k:
                    reservoir[j] = item

        return reservoir

# BigQuery sampling (more efficient for large datasets)
def bigquery_sampling(project_id, dataset_id, table_id, sample_size=0.1):
    """Sample directly from BigQuery"""
    from google.cloud import bigquery

    client = bigquery.Client(project=project_id)

    # Percentage-based sampling
    query = f"""
        SELECT *
        FROM `{project_id}.{dataset_id}.{table_id}`
        TABLESAMPLE SYSTEM ({sample_size * 100} PERCENT)
    """

    return client.query(query).to_dataframe()
```

### Handling Imbalanced Data

```python
from imblearn.over_sampling import SMOTE, ADASYN, BorderlineSMOTE, SVMSMOTE
from imblearn.under_sampling import RandomUnderSampler, TomekLinks, NearMiss
from imblearn.combine import SMOTETomek, SMOTEENN
from collections import Counter
import tensorflow as tf

class ImbalanceHandler:
    """Handle imbalanced datasets"""

    def __init__(self, X, y):
        self.X = X
        self.y = y
        print(f"Original distribution: {Counter(y)}")

    def oversample_smote(self, sampling_strategy='auto', k_neighbors=5):
        """SMOTE oversampling"""
        smote = SMOTE(sampling_strategy=sampling_strategy, k_neighbors=k_neighbors, random_state=42)
        X_res, y_res = smote.fit_resample(self.X, self.y)
        print(f"After SMOTE: {Counter(y_res)}")
        return X_res, y_res

    def oversample_adasyn(self, sampling_strategy='auto'):
        """ADASYN adaptive oversampling"""
        adasyn = ADASYN(sampling_strategy=sampling_strategy, random_state=42)
        X_res, y_res = adasyn.fit_resample(self.X, self.y)
        print(f"After ADASYN: {Counter(y_res)}")
        return X_res, y_res

    def undersample_random(self, sampling_strategy='auto'):
        """Random undersampling"""
        undersampler = RandomUnderSampler(sampling_strategy=sampling_strategy, random_state=42)
        X_res, y_res = undersampler.fit_resample(self.X, self.y)
        print(f"After undersampling: {Counter(y_res)}")
        return X_res, y_res

    def combined_smote_tomek(self):
        """Combined over and undersampling"""
        smotetomek = SMOTETomek(random_state=42)
        X_res, y_res = smotetomek.fit_resample(self.X, self.y)
        print(f"After SMOTE-Tomek: {Counter(y_res)}")
        return X_res, y_res

    def class_weights(self):
        """Calculate class weights for model training"""
        from sklearn.utils.class_weight import compute_class_weight

        classes = np.unique(self.y)
        weights = compute_class_weight('balanced', classes=classes, y=self.y)
        class_weight_dict = dict(zip(classes, weights))

        return class_weight_dict

# TensorFlow class weights
def create_class_weight_tensor(y):
    """Create class weights for TensorFlow"""
    from sklearn.utils.class_weight import compute_class_weight

    classes = np.unique(y)
    class_weights = compute_class_weight('balanced', classes=classes, y=y)
    class_weight_dict = dict(zip(classes, class_weights))

    return class_weight_dict

# Example usage in model training
model = tf.keras.models.Sequential([...])
class_weights = create_class_weight_tensor(y_train)
model.fit(X_train, y_train, class_weight=class_weights)

# Focal loss for imbalanced data
def focal_loss(gamma=2., alpha=0.25):
    """Focal loss for handling class imbalance"""
    def focal_loss_fixed(y_true, y_pred):
        epsilon = tf.keras.backend.epsilon()
        y_pred = tf.keras.backend.clip(y_pred, epsilon, 1. - epsilon)

        cross_entropy = -y_true * tf.keras.backend.log(y_pred)
        loss = alpha * tf.keras.backend.pow(1 - y_pred, gamma) * cross_entropy

        return tf.keras.backend.mean(tf.keras.backend.sum(loss, axis=1))

    return focal_loss_fixed
```

### Data Augmentation

```python
import tensorflow as tf
import numpy as np

# Image augmentation
def image_augmentation():
    """Image data augmentation pipeline"""

    data_augmentation = tf.keras.Sequential([
        tf.keras.layers.RandomFlip("horizontal_and_vertical"),
        tf.keras.layers.RandomRotation(0.2),
        tf.keras.layers.RandomZoom(0.2),
        tf.keras.layers.RandomContrast(0.2),
        tf.keras.layers.RandomBrightness(0.2),
    ])

    return data_augmentation

# Text augmentation
def text_augmentation(text, augmentation_type='synonym'):
    """Text data augmentation"""
    import nlpaug.augmenter.word as naw
    import nlpaug.augmenter.char as nac

    if augmentation_type == 'synonym':
        aug = naw.SynonymAug(aug_src='wordnet')
    elif augmentation_type == 'word2vec':
        aug = naw.WordEmbsAug(
            model_type='word2vec',
            model_path='GoogleNews-vectors-negative300.bin'
        )
    elif augmentation_type == 'contextual':
        aug = naw.ContextualWordEmbsAug(
            model_path='bert-base-uncased',
            action='substitute'
        )
    elif augmentation_type == 'backtranslation':
        aug = naw.BackTranslationAug(
            from_model_name='facebook/wmt19-en-de',
            to_model_name='facebook/wmt19-de-en'
        )

    return aug.augment(text)

# Tabular data augmentation
class TabularAugmentation:
    """Augmentation for tabular data"""

    @staticmethod
    def gaussian_noise(X, noise_level=0.01):
        """Add Gaussian noise to numeric features"""
        noise = np.random.normal(0, noise_level, X.shape)
        return X + noise

    @staticmethod
    def mixup(X, y, alpha=0.2):
        """Mixup augmentation for tabular data"""
        if len(X) < 2:
            return X, y

        lambda_param = np.random.beta(alpha, alpha)
        indices = np.random.permutation(len(X))

        X_mixed = lambda_param * X + (1 - lambda_param) * X[indices]
        y_mixed = lambda_param * y + (1 - lambda_param) * y[indices]

        return X_mixed, y_mixed

    @staticmethod
    def smote_augmentation(X, y, target_samples):
        """Use SMOTE for data augmentation"""
        from imblearn.over_sampling import SMOTE

        smote = SMOTE(sampling_strategy={1: target_samples}, random_state=42)
        X_aug, y_aug = smote.fit_resample(X, y)

        return X_aug, y_aug
```

### Data Splitting Best Practices

```python
from sklearn.model_selection import (
    train_test_split,
    KFold,
    StratifiedKFold,
    TimeSeriesSplit,
    GroupKFold
)

class DataSplitter:
    """Comprehensive data splitting strategies"""

    @staticmethod
    def basic_split(X, y, test_size=0.2, val_size=0.1, random_state=42):
        """Basic train/val/test split"""
        # First split: train+val vs test
        X_temp, X_test, y_temp, y_test = train_test_split(
            X, y, test_size=test_size, random_state=random_state
        )

        # Second split: train vs val
        val_size_adjusted = val_size / (1 - test_size)
        X_train, X_val, y_train, y_val = train_test_split(
            X_temp, y_temp, test_size=val_size_adjusted, random_state=random_state
        )

        return X_train, X_val, X_test, y_train, y_val, y_test

    @staticmethod
    def stratified_split(X, y, test_size=0.2, random_state=42):
        """Stratified split maintaining class distribution"""
        return train_test_split(
            X, y, test_size=test_size, stratify=y, random_state=random_state
        )

    @staticmethod
    def time_series_split(X, y, n_splits=5):
        """Time series cross-validation"""
        tscv = TimeSeriesSplit(n_splits=n_splits)

        for train_idx, test_idx in tscv.split(X):
            X_train, X_test = X[train_idx], X[test_idx]
            y_train, y_test = y[train_idx], y[test_idx]
            yield X_train, X_test, y_train, y_test

    @staticmethod
    def group_split(X, y, groups, n_splits=5):
        """Group-based split (e.g., by customer, location)"""
        gkf = GroupKFold(n_splits=n_splits)

        for train_idx, test_idx in gkf.split(X, y, groups):
            X_train, X_test = X[train_idx], X[test_idx]
            y_train, y_test = y[train_idx], y[test_idx]
            yield X_train, X_test, y_train, y_test

    @staticmethod
    def stratified_group_split(X, y, groups, test_size=0.2):
        """Stratified split respecting groups"""
        from sklearn.model_selection import StratifiedGroupKFold

        sgkf = StratifiedGroupKFold(n_splits=int(1/test_size))
        train_idx, test_idx = next(sgkf.split(X, y, groups))

        return X[train_idx], X[test_idx], y[train_idx], y[test_idx]

# BigQuery data splitting
def bigquery_split(project_id, dataset_id, table_id, train_ratio=0.7, val_ratio=0.15):
    """Split data in BigQuery for large datasets"""
    from google.cloud import bigquery

    client = bigquery.Client(project=project_id)

    # Create deterministic splits using hash
    query = f"""
    CREATE OR REPLACE TABLE `{dataset_id}.train_data` AS
    SELECT * FROM `{dataset_id}.{table_id}`
    WHERE MOD(ABS(FARM_FINGERPRINT(CAST(id AS STRING))), 100) < {int(train_ratio * 100)};

    CREATE OR REPLACE TABLE `{dataset_id}.val_data` AS
    SELECT * FROM `{dataset_id}.{table_id}`
    WHERE MOD(ABS(FARM_FINGERPRINT(CAST(id AS STRING))), 100) >= {int(train_ratio * 100)}
      AND MOD(ABS(FARM_FINGERPRINT(CAST(id AS STRING))), 100) < {int((train_ratio + val_ratio) * 100)};

    CREATE OR REPLACE TABLE `{dataset_id}.test_data` AS
    SELECT * FROM `{dataset_id}.{table_id}`
    WHERE MOD(ABS(FARM_FINGERPRINT(CAST(id AS STRING))), 100) >= {int((train_ratio + val_ratio) * 100)};
    """

    client.query(query).result()
```

## Feature Engineering

### Scaling and Normalization

**Feature Scaling Techniques**:

```python
import numpy as np
import pandas as pd
from sklearn.preprocessing import (
    StandardScaler,
    MinMaxScaler,
    RobustScaler,
    MaxAbsScaler,
    Normalizer,
    QuantileTransformer,
    PowerTransformer
)

class FeatureScaler:
    """Comprehensive feature scaling methods"""

    def __init__(self, df):
        self.df = df.copy()
        self.scalers = {}

    def standard_scaling(self, columns):
        """Z-score normalization: (x - mean) / std"""
        scaler = StandardScaler()
        self.df[columns] = scaler.fit_transform(self.df[columns])
        self.scalers['standard'] = scaler
        return self

    def minmax_scaling(self, columns, feature_range=(0, 1)):
        """Min-Max scaling: (x - min) / (max - min)"""
        scaler = MinMaxScaler(feature_range=feature_range)
        self.df[columns] = scaler.fit_transform(self.df[columns])
        self.scalers['minmax'] = scaler
        return self

    def robust_scaling(self, columns):
        """Robust to outliers using IQR"""
        scaler = RobustScaler()
        self.df[columns] = scaler.fit_transform(self.df[columns])
        self.scalers['robust'] = scaler
        return self

    def maxabs_scaling(self, columns):
        """Scale by maximum absolute value"""
        scaler = MaxAbsScaler()
        self.df[columns] = scaler.fit_transform(self.df[columns])
        self.scalers['maxabs'] = scaler
        return self

    def log_transform(self, columns):
        """Log transformation for skewed data"""
        for col in columns:
            self.df[f'{col}_log'] = np.log1p(self.df[col])
        return self

    def box_cox_transform(self, columns):
        """Box-Cox transformation"""
        transformer = PowerTransformer(method='box-cox')
        # Box-Cox requires positive values
        for col in columns:
            if (self.df[col] > 0).all():
                self.df[col] = transformer.fit_transform(self.df[[col]])
        return self

    def yeo_johnson_transform(self, columns):
        """Yeo-Johnson transformation (handles negative values)"""
        transformer = PowerTransformer(method='yeo-johnson')
        self.df[columns] = transformer.fit_transform(self.df[columns])
        return self

    def quantile_transform(self, columns, n_quantiles=1000):
        """Quantile transformation to uniform/normal distribution"""
        transformer = QuantileTransformer(
            n_quantiles=n_quantiles,
            output_distribution='normal',
            random_state=42
        )
        self.df[columns] = transformer.fit_transform(self.df[columns])
        return self

    def get_transformed_data(self):
        return self.df, self.scalers

# TensorFlow scaling
def tf_scaling_layer():
    """TensorFlow normalization layers"""
    import tensorflow as tf

    # Normalization layer
    normalizer = tf.keras.layers.Normalization(axis=-1)

    # Adapt to training data
    normalizer.adapt(training_data)

    return normalizer
```

### Encoding Categorical Features

```python
import pandas as pd
import numpy as np
from sklearn.preprocessing import (
    OneHotEncoder,
    LabelEncoder,
    OrdinalEncoder,
    TargetEncoder
)
import category_encoders as ce

class CategoricalEncoder:
    """Comprehensive categorical encoding strategies"""

    def __init__(self, df):
        self.df = df.copy()
        self.encoders = {}

    def one_hot_encoding(self, columns, drop_first=False):
        """One-hot encoding for nominal features"""
        for col in columns:
            dummies = pd.get_dummies(
                self.df[col],
                prefix=col,
                drop_first=drop_first
            )
            self.df = pd.concat([self.df, dummies], axis=1)
            self.df.drop(columns=[col], inplace=True)
        return self

    def label_encoding(self, columns):
        """Label encoding for ordinal features"""
        for col in columns:
            le = LabelEncoder()
            self.df[col] = le.fit_transform(self.df[col])
            self.encoders[f'{col}_label'] = le
        return self

    def ordinal_encoding(self, column, categories):
        """Ordinal encoding with specific order"""
        encoder = OrdinalEncoder(categories=[categories])
        self.df[column] = encoder.fit_transform(self.df[[column]])
        self.encoders[f'{column}_ordinal'] = encoder
        return self

    def target_encoding(self, columns, target):
        """Target encoding (mean encoding)"""
        for col in columns:
            encoder = ce.TargetEncoder(cols=[col])
            self.df[col] = encoder.fit_transform(self.df[col], self.df[target])
            self.encoders[f'{col}_target'] = encoder
        return self

    def frequency_encoding(self, columns):
        """Frequency encoding"""
        for col in columns:
            freq_map = self.df[col].value_counts(normalize=True).to_dict()
            self.df[f'{col}_freq'] = self.df[col].map(freq_map)
        return self

    def binary_encoding(self, columns):
        """Binary encoding for high cardinality features"""
        for col in columns:
            encoder = ce.BinaryEncoder(cols=[col])
            encoded = encoder.fit_transform(self.df[col])
            self.df = pd.concat([self.df.drop(columns=[col]), encoded], axis=1)
            self.encoders[f'{col}_binary'] = encoder
        return self

    def hashing_encoding(self, columns, n_components=8):
        """Hashing encoding for high cardinality"""
        for col in columns:
            encoder = ce.HashingEncoder(cols=[col], n_components=n_components)
            encoded = encoder.fit_transform(self.df[col])
            self.df = pd.concat([self.df.drop(columns=[col]), encoded], axis=1)
        return self

    def get_encoded_data(self):
        return self.df, self.encoders

# TensorFlow categorical encoding
def tf_categorical_layers(vocabulary):
    """TensorFlow categorical encoding layers"""
    import tensorflow as tf

    # String lookup layer
    string_lookup = tf.keras.layers.StringLookup(
        vocabulary=vocabulary,
        output_mode='int'
    )

    # Integer lookup layer
    integer_lookup = tf.keras.layers.IntegerLookup(
        vocabulary=vocabulary,
        output_mode='one_hot'
    )

    # Hashing layer for high cardinality
    hashing = tf.keras.layers.Hashing(num_bins=100)

    return string_lookup, integer_lookup, hashing
```

### Feature Binning and Discretization

```python
import numpy as np
import pandas as pd
from sklearn.preprocessing import KBinsDiscretizer

class FeatureBinner:
    """Discretize continuous features into bins"""

    def __init__(self, df):
        self.df = df.copy()

    def equal_width_binning(self, column, n_bins=5):
        """Equal-width binning"""
        self.df[f'{column}_binned'] = pd.cut(
            self.df[column],
            bins=n_bins,
            labels=False
        )
        return self

    def equal_frequency_binning(self, column, n_bins=5):
        """Equal-frequency (quantile) binning"""
        self.df[f'{column}_binned'] = pd.qcut(
            self.df[column],
            q=n_bins,
            labels=False,
            duplicates='drop'
        )
        return self

    def custom_binning(self, column, bins, labels=None):
        """Custom bin edges"""
        self.df[f'{column}_binned'] = pd.cut(
            self.df[column],
            bins=bins,
            labels=labels,
            include_lowest=True
        )
        return self

    def kmeans_binning(self, column, n_bins=5):
        """KMeans-based binning"""
        discretizer = KBinsDiscretizer(
            n_bins=n_bins,
            encode='ordinal',
            strategy='kmeans'
        )
        self.df[f'{column}_binned'] = discretizer.fit_transform(
            self.df[[column]]
        )
        return self

    def get_binned_data(self):
        return self.df

# Example: Age binning
binner = FeatureBinner(df)
df_binned = (binner
    .custom_binning('age', bins=[0, 18, 35, 50, 65, 100],
                    labels=['child', 'young_adult', 'adult', 'senior', 'elderly'])
    .get_binned_data())
```

### Feature Crosses and Interactions

```python
import pandas as pd
import numpy as np
from sklearn.preprocessing import PolynomialFeatures
from itertools import combinations

class FeatureCrosser:
    """Create feature crosses and interactions"""

    def __init__(self, df):
        self.df = df.copy()

    def simple_cross(self, col1, col2):
        """Simple feature cross"""
        self.df[f'{col1}_X_{col2}'] = (
            self.df[col1].astype(str) + '_' + self.df[col2].astype(str)
        )
        return self

    def numeric_interaction(self, col1, col2, operation='multiply'):
        """Numeric feature interactions"""
        if operation == 'multiply':
            self.df[f'{col1}_times_{col2}'] = self.df[col1] * self.df[col2]
        elif operation == 'add':
            self.df[f'{col1}_plus_{col2}'] = self.df[col1] + self.df[col2]
        elif operation == 'subtract':
            self.df[f'{col1}_minus_{col2}'] = self.df[col1] - self.df[col2]
        elif operation == 'divide':
            self.df[f'{col1}_div_{col2}'] = self.df[col1] / (self.df[col2] + 1e-10)
        elif operation == 'ratio':
            self.df[f'{col1}_ratio_{col2}'] = (
                self.df[col1] / (self.df[col1] + self.df[col2] + 1e-10)
            )
        return self

    def polynomial_features(self, columns, degree=2, include_bias=False):
        """Generate polynomial features"""
        poly = PolynomialFeatures(
            degree=degree,
            include_bias=include_bias,
            interaction_only=False
        )
        poly_features = poly.fit_transform(self.df[columns])
        feature_names = poly.get_feature_names_out(columns)

        poly_df = pd.DataFrame(poly_features, columns=feature_names, index=self.df.index)
        self.df = pd.concat([self.df, poly_df.iloc[:, len(columns):]], axis=1)
        return self

    def all_pairwise_interactions(self, columns):
        """Create all pairwise interactions"""
        for col1, col2 in combinations(columns, 2):
            self.df[f'{col1}_X_{col2}'] = self.df[col1] * self.df[col2]
        return self

    def get_crossed_data(self):
        return self.df

# Example usage
crosser = FeatureCrosser(df)
df_crossed = (crosser
    .simple_cross('category', 'region')
    .numeric_interaction('price', 'quantity', operation='multiply')
    .polynomial_features(['feature1', 'feature2'], degree=2)
    .get_crossed_data())
```

### Temporal Features

```python
import pandas as pd
import numpy as np
from datetime import datetime

class TemporalFeatureEngineer:
    """Extract temporal features from datetime columns"""

    def __init__(self, df, datetime_col):
        self.df = df.copy()
        self.datetime_col = datetime_col

        # Ensure datetime type
        if not pd.api.types.is_datetime64_any_dtype(self.df[datetime_col]):
            self.df[datetime_col] = pd.to_datetime(self.df[datetime_col])

    def extract_basic_features(self):
        """Extract basic temporal features"""
        dt_col = self.df[self.datetime_col]

        self.df['year'] = dt_col.dt.year
        self.df['month'] = dt_col.dt.month
        self.df['day'] = dt_col.dt.day
        self.df['dayofweek'] = dt_col.dt.dayofweek
        self.df['dayofyear'] = dt_col.dt.dayofyear
        self.df['quarter'] = dt_col.dt.quarter
        self.df['weekofyear'] = dt_col.dt.isocalendar().week
        self.df['hour'] = dt_col.dt.hour
        self.df['minute'] = dt_col.dt.minute

        return self

    def extract_cyclical_features(self):
        """Convert cyclical features to sin/cos"""
        dt_col = self.df[self.datetime_col]

        # Month cyclical
        self.df['month_sin'] = np.sin(2 * np.pi * dt_col.dt.month / 12)
        self.df['month_cos'] = np.cos(2 * np.pi * dt_col.dt.month / 12)

        # Day of week cyclical
        self.df['dayofweek_sin'] = np.sin(2 * np.pi * dt_col.dt.dayofweek / 7)
        self.df['dayofweek_cos'] = np.cos(2 * np.pi * dt_col.dt.dayofweek / 7)

        # Hour cyclical
        self.df['hour_sin'] = np.sin(2 * np.pi * dt_col.dt.hour / 24)
        self.df['hour_cos'] = np.cos(2 * np.pi * dt_col.dt.hour / 24)

        return self

    def extract_derived_features(self):
        """Extract derived temporal features"""
        dt_col = self.df[self.datetime_col]

        # Weekend flag
        self.df['is_weekend'] = (dt_col.dt.dayofweek >= 5).astype(int)

        # Month start/end flags
        self.df['is_month_start'] = dt_col.dt.is_month_start.astype(int)
        self.df['is_month_end'] = dt_col.dt.is_month_end.astype(int)

        # Quarter start/end
        self.df['is_quarter_start'] = dt_col.dt.is_quarter_start.astype(int)
        self.df['is_quarter_end'] = dt_col.dt.is_quarter_end.astype(int)

        # Business day
        self.df['is_business_day'] = (dt_col.dt.dayofweek < 5).astype(int)

        # Season (Northern Hemisphere)
        month = dt_col.dt.month
        self.df['season'] = pd.cut(
            month,
            bins=[0, 3, 6, 9, 12],
            labels=['winter', 'spring', 'summer', 'fall']
        )

        # Part of day
        hour = dt_col.dt.hour
        self.df['part_of_day'] = pd.cut(
            hour,
            bins=[0, 6, 12, 18, 24],
            labels=['night', 'morning', 'afternoon', 'evening']
        )

        return self

    def extract_lag_features(self, value_col, periods=[1, 7, 30]):
        """Create lag features"""
        for period in periods:
            self.df[f'{value_col}_lag_{period}'] = self.df[value_col].shift(period)
        return self

    def extract_rolling_features(self, value_col, windows=[7, 30, 90]):
        """Create rolling window features"""
        for window in windows:
            self.df[f'{value_col}_rolling_mean_{window}'] = (
                self.df[value_col].rolling(window=window).mean()
            )
            self.df[f'{value_col}_rolling_std_{window}'] = (
                self.df[value_col].rolling(window=window).std()
            )
            self.df[f'{value_col}_rolling_min_{window}'] = (
                self.df[value_col].rolling(window=window).min()
            )
            self.df[f'{value_col}_rolling_max_{window}'] = (
                self.df[value_col].rolling(window=window).max()
            )
        return self

    def extract_time_since(self, reference_date=None):
        """Time elapsed since reference date"""
        if reference_date is None:
            reference_date = self.df[self.datetime_col].max()

        self.df['days_since'] = (
            reference_date - self.df[self.datetime_col]
        ).dt.days
        self.df['hours_since'] = (
            reference_date - self.df[self.datetime_col]
        ).dt.total_seconds() / 3600

        return self

    def get_engineered_data(self):
        return self.df

# Example usage
temporal_engineer = TemporalFeatureEngineer(df, 'transaction_date')
df_temporal = (temporal_engineer
    .extract_basic_features()
    .extract_cyclical_features()
    .extract_derived_features()
    .extract_lag_features('sales', periods=[1, 7, 30])
    .extract_rolling_features('sales', windows=[7, 30])
    .get_engineered_data())
```

### Embedding Features

```python
import tensorflow as tf
import numpy as np

# Categorical embeddings
def create_embedding_model(vocabulary_size, embedding_dim=8):
    """Create embedding layer for categorical features"""

    model = tf.keras.Sequential([
        tf.keras.layers.Embedding(
            input_dim=vocabulary_size,
            output_dim=embedding_dim,
            name='category_embedding'
        ),
        tf.keras.layers.Flatten()
    ])

    return model

# Entity embeddings for multiple categorical features
def create_entity_embeddings(categorical_features, embedding_dims):
    """Create entity embeddings for tabular data"""

    inputs = []
    embeddings = []

    for feature_name, vocab_size in categorical_features.items():
        input_layer = tf.keras.layers.Input(shape=(1,), name=f'{feature_name}_input')
        inputs.append(input_layer)

        embedding_dim = embedding_dims.get(feature_name, min(50, vocab_size // 2))
        embedding = tf.keras.layers.Embedding(
            input_dim=vocab_size,
            output_dim=embedding_dim,
            name=f'{feature_name}_embedding'
        )(input_layer)
        embedding = tf.keras.layers.Flatten()(embedding)
        embeddings.append(embedding)

    # Concatenate all embeddings
    if len(embeddings) > 1:
        concatenated = tf.keras.layers.Concatenate()(embeddings)
    else:
        concatenated = embeddings[0]

    return inputs, concatenated

# Word embeddings
def create_text_embeddings(max_features, embedding_dim=100, max_length=100):
    """Create text embeddings using pretrained or learned embeddings"""

    # Trainable embeddings
    model = tf.keras.Sequential([
        tf.keras.layers.Embedding(
            input_dim=max_features,
            output_dim=embedding_dim,
            input_length=max_length
        ),
        tf.keras.layers.GlobalAveragePooling1D()
    ])

    return model

# Using pretrained embeddings (e.g., GloVe, Word2Vec)
def load_pretrained_embeddings(embedding_path, word_index, embedding_dim=100):
    """Load pretrained embeddings"""

    embeddings_index = {}
    with open(embedding_path, encoding='utf-8') as f:
        for line in f:
            values = line.split()
            word = values[0]
            coefs = np.asarray(values[1:], dtype='float32')
            embeddings_index[word] = coefs

    # Create embedding matrix
    embedding_matrix = np.zeros((len(word_index) + 1, embedding_dim))
    for word, i in word_index.items():
        embedding_vector = embeddings_index.get(word)
        if embedding_vector is not None:
            embedding_matrix[i] = embedding_vector

    # Create embedding layer with pretrained weights
    embedding_layer = tf.keras.layers.Embedding(
        len(word_index) + 1,
        embedding_dim,
        weights=[embedding_matrix],
        trainable=False  # Freeze pretrained embeddings
    )

    return embedding_layer
```

### Feature Selection

```python
import pandas as pd
import numpy as np
from sklearn.feature_selection import (
    SelectKBest,
    SelectPercentile,
    RFE,
    RFECV,
    SelectFromModel,
    f_classif,
    f_regression,
    mutual_info_classif,
    mutual_info_regression,
    chi2
)
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor
import xgboost as xgb
import matplotlib.pyplot as plt
import seaborn as sns

class FeatureSelector:
    """Comprehensive feature selection methods"""

    def __init__(self, X, y, task='classification'):
        self.X = X
        self.y = y
        self.task = task
        self.selected_features = None

    def correlation_filter(self, threshold=0.95):
        """Remove highly correlated features"""
        corr_matrix = self.X.corr().abs()
        upper_triangle = corr_matrix.where(
            np.triu(np.ones(corr_matrix.shape), k=1).astype(bool)
        )

        to_drop = [
            column for column in upper_triangle.columns
            if any(upper_triangle[column] > threshold)
        ]

        self.selected_features = [col for col in self.X.columns if col not in to_drop]
        print(f"Removed {len(to_drop)} highly correlated features")
        return self

    def variance_threshold(self, threshold=0.01):
        """Remove low variance features"""
        from sklearn.feature_selection import VarianceThreshold

        selector = VarianceThreshold(threshold=threshold)
        selector.fit(self.X)

        self.selected_features = self.X.columns[selector.get_support()].tolist()
        print(f"Selected {len(self.selected_features)} features with variance > {threshold}")
        return self

    def univariate_selection(self, k=10, score_func=None):
        """Univariate statistical tests"""
        if score_func is None:
            score_func = f_classif if self.task == 'classification' else f_regression

        selector = SelectKBest(score_func=score_func, k=k)
        selector.fit(self.X, self.y)

        self.selected_features = self.X.columns[selector.get_support()].tolist()
        scores = pd.DataFrame({
            'feature': self.X.columns,
            'score': selector.scores_
        }).sort_values('score', ascending=False)

        print(f"\nTop {k} features by univariate selection:")
        print(scores.head(k))
        return self

    def mutual_information_selection(self, k=10):
        """Mutual information feature selection"""
        mi_func = (mutual_info_classif if self.task == 'classification'
                   else mutual_info_regression)

        mi_scores = mi_func(self.X, self.y, random_state=42)
        mi_df = pd.DataFrame({
            'feature': self.X.columns,
            'mi_score': mi_scores
        }).sort_values('mi_score', ascending=False)

        self.selected_features = mi_df.head(k)['feature'].tolist()
        print(f"\nTop {k} features by mutual information:")
        print(mi_df.head(k))
        return self

    def recursive_feature_elimination(self, n_features_to_select=10, cv=None):
        """RFE with cross-validation"""
        if self.task == 'classification':
            estimator = RandomForestClassifier(n_estimators=100, random_state=42)
        else:
            estimator = RandomForestRegressor(n_estimators=100, random_state=42)

        if cv is not None:
            selector = RFECV(
                estimator=estimator,
                step=1,
                cv=cv,
                scoring='accuracy' if self.task == 'classification' else 'r2',
                n_jobs=-1
            )
        else:
            selector = RFE(
                estimator=estimator,
                n_features_to_select=n_features_to_select,
                step=1
            )

        selector.fit(self.X, self.y)
        self.selected_features = self.X.columns[selector.get_support()].tolist()

        print(f"\nSelected {len(self.selected_features)} features via RFE")
        if cv is not None:
            print(f"Optimal number of features: {selector.n_features_}")
        return self

    def tree_based_selection(self, threshold='median'):
        """Tree-based feature importance selection"""
        if self.task == 'classification':
            model = RandomForestClassifier(n_estimators=100, random_state=42)
        else:
            model = RandomForestRegressor(n_estimators=100, random_state=42)

        model.fit(self.X, self.y)

        selector = SelectFromModel(model, threshold=threshold, prefit=True)
        self.selected_features = self.X.columns[selector.get_support()].tolist()

        # Plot feature importance
        importances = pd.DataFrame({
            'feature': self.X.columns,
            'importance': model.feature_importances_
        }).sort_values('importance', ascending=False)

        print(f"\nTop 20 features by importance:")
        print(importances.head(20))

        plt.figure(figsize=(12, 6))
        plt.bar(range(min(20, len(importances))), importances.head(20)['importance'])
        plt.xticks(range(min(20, len(importances))), importances.head(20)['feature'], rotation=45)
        plt.xlabel('Features')
        plt.ylabel('Importance')
        plt.title('Feature Importance')
        plt.tight_layout()
        plt.show()

        return self

    def l1_regularization_selection(self, C=1.0):
        """L1 (Lasso) regularization for feature selection"""
        from sklearn.linear_model import LogisticRegression, Lasso
        from sklearn.preprocessing import StandardScaler

        # Scale features for L1
        scaler = StandardScaler()
        X_scaled = scaler.fit_transform(self.X)

        if self.task == 'classification':
            model = LogisticRegression(penalty='l1', C=C, solver='liblinear', random_state=42)
        else:
            model = Lasso(alpha=1/C, random_state=42)

        model.fit(X_scaled, self.y)

        if self.task == 'classification':
            coefficients = np.abs(model.coef_[0])
        else:
            coefficients = np.abs(model.coef_)

        self.selected_features = self.X.columns[coefficients > 0].tolist()
        print(f"\nSelected {len(self.selected_features)} features via L1 regularization")
        return self

    def permutation_importance(self, n_repeats=10):
        """Permutation importance"""
        from sklearn.inspection import permutation_importance

        if self.task == 'classification':
            model = RandomForestClassifier(n_estimators=100, random_state=42)
            scoring = 'accuracy'
        else:
            model = RandomForestRegressor(n_estimators=100, random_state=42)
            scoring = 'r2'

        model.fit(self.X, self.y)

        perm_importance = permutation_importance(
            model, self.X, self.y,
            n_repeats=n_repeats,
            random_state=42,
            scoring=scoring,
            n_jobs=-1
        )

        importance_df = pd.DataFrame({
            'feature': self.X.columns,
            'importance_mean': perm_importance.importances_mean,
            'importance_std': perm_importance.importances_std
        }).sort_values('importance_mean', ascending=False)

        print("\nPermutation Importance:")
        print(importance_df.head(20))

        return self

    def get_selected_features(self):
        """Return selected features"""
        if self.selected_features is None:
            return self.X.columns.tolist()
        return self.selected_features

    def transform(self, X):
        """Transform dataset with selected features"""
        if self.selected_features is None:
            return X
        return X[self.selected_features]

# Example usage
selector = FeatureSelector(X_train, y_train, task='classification')
selector.tree_based_selection(threshold='median')
selected_features = selector.get_selected_features()
X_train_selected = selector.transform(X_train)
```

### Vertex AI Feature Store

**Architecture and Concepts**:
- **Featurestore**: Container for all features
- **Entity Type**: Represents an object (e.g., user, product)
- **Feature**: Individual feature within an entity
- **Online Serving**: Low-latency feature retrieval for predictions
- **Offline Serving**: Batch feature retrieval for training
- **Point-in-time lookup**: Historical feature values at specific timestamps

**Creating and Managing Feature Store**:

```python
from google.cloud import aiplatform
from google.cloud.aiplatform import Feature, EntityType, Featurestore
import pandas as pd

# Initialize Vertex AI
aiplatform.init(project='your-project-id', location='us-central1')

# Create Featurestore
featurestore = Featurestore.create(
    featurestore_id='customer_featurestore',
    online_store_fixed_node_count=1,  # For online serving
    labels={'environment': 'production'}
)

# Create Entity Type
entity_type = featurestore.create_entity_type(
    entity_type_id='customer',
    description='Customer entity type'
)

# Batch ingestion from BigQuery
entity_type.batch_create_features({
    'age': {'value_type': 'INT64', 'description': 'Customer age'},
    'ltv': {'value_type': 'DOUBLE', 'description': 'Lifetime value'},
    'is_premium': {'value_type': 'BOOL', 'description': 'Premium status'},
    'last_purchase_date': {'value_type': 'STRING', 'description': 'Last purchase'}
})

entity_type.ingest_from_bq(
    feature_ids=['age', 'ltv', 'is_premium'],
    feature_time='timestamp',
    bq_source_uri='bq://project.dataset.table',
    entity_id_field='customer_id'
)
```

**Feature Serving**:
```python
# Online serving (low latency)
features = entity_type.read(
    entity_ids=['customer_123', 'customer_456']
)

# Batch serving
batch_features = entity_type.batch_serve_to_bq(
    bq_destination_output_uri='bq://project.dataset.output_table',
    read_instances_uri='bq://project.dataset.entity_ids'
)
```

### Feature Transformation
**TensorFlow Transform**:
```python
import tensorflow_transform as tft

def preprocessing_fn(inputs):
    """Transform features"""
    # Normalize numeric
    age_normalized = tft.scale_to_z_score(inputs['age'])

    # Bucketize
    age_buckets = tft.bucketize(inputs['age'], num_buckets=5)

    # Vocabulary for categorical
    category_integerized = tft.compute_and_apply_vocabulary(
        inputs['category'], top_k=100
    )

    # Feature crossing
    age_category_cross = tft.hash(
        tf.strings.join([
            tf.as_string(age_buckets),
            tf.as_string(category_integerized)
        ]),
        hash_bucket_size=1000
    )

    return {
        'age_normalized': age_normalized,
        'age_buckets': age_buckets,
        'category': category_integerized,
        'age_category_cross': age_category_cross
    }
```

### Feature Selection (model-based)
```python
# Feature importance from model
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestClassifier

rf = RandomForestClassifier()
rf.fit(X_train, y_train)

# Plot feature importance
importances = rf.feature_importances_
indices = np.argsort(importances)[::-1]

plt.figure(figsize=(12, 6))
plt.bar(range(X.shape[1]), importances[indices])
plt.xlabel('Feature')
plt.ylabel('Importance')
plt.show()

# Select top features
from sklearn.feature_selection import SelectKBest, f_classif

selector = SelectKBest(f_classif, k=10)
X_selected = selector.fit_transform(X_train, y_train)
```

## Data Pipelines

### Dataflow for ML Data Prep
```python
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions

def preprocess_features(element):
    """Transform raw data to features"""
    import json

    record = json.loads(element)

    # Feature engineering
    features = {
        'age': int(record['age']),
        'is_premium': record['subscription'] == 'premium',
        'days_since_signup': (datetime.now() -
            datetime.fromisoformat(record['signup_date'])).days,
        'total_purchases': float(record['purchase_count'])
    }

    return features

pipeline_options = PipelineOptions(
    runner='DataflowRunner',
    project='project-id',
    region='us-central1',
    temp_location='gs://bucket/temp'
)

with beam.Pipeline(options=pipeline_options) as p:
    (p
     | 'Read from Pub/Sub' >> beam.io.ReadFromPubSub(subscription=SUB)
     | 'Parse and Transform' >> beam.Map(preprocess_features)
     | 'Write to BigQuery' >> beam.io.WriteToBigQuery(
         table='project:dataset.features',
         schema='age:INTEGER,is_premium:BOOLEAN,...'
     ))
```

### BigQuery for Feature Engineering
```sql
-- Create training dataset
CREATE OR REPLACE TABLE `dataset.training_features` AS
WITH customer_features AS (
  SELECT
    customer_id,
    DATE_DIFF(CURRENT_DATE(), signup_date, DAY) as days_since_signup,
    COUNT(DISTINCT order_id) as total_orders,
    SUM(order_amount) as total_spent,
    AVG(order_amount) as avg_order_value,
    MAX(order_date) as last_order_date
  FROM `dataset.orders`
  GROUP BY customer_id, signup_date
),
rfm_features AS (
  SELECT
    customer_id,
    DATE_DIFF(CURRENT_DATE(), MAX(order_date), DAY) as recency,
    COUNT(*) as frequency,
    SUM(order_amount) as monetary
  FROM `dataset.orders`
  GROUP BY customer_id
)
SELECT
  c.*,
  r.recency,
  r.frequency,
  r.monetary,
  CASE
    WHEN r.recency < 30 AND r.frequency > 5 THEN 1
    ELSE 0
  END as is_active_customer
FROM customer_features c
JOIN rfm_features r USING(customer_id);

-- Aggregate features with window functions
CREATE OR REPLACE TABLE `dataset.time_series_features` AS
SELECT
  customer_id,
  order_date,
  order_amount,
  AVG(order_amount) OVER (
    PARTITION BY customer_id
    ORDER BY order_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) as avg_7day_order_amount,
  LAG(order_amount, 1) OVER (
    PARTITION BY customer_id ORDER BY order_date
  ) as prev_order_amount
FROM `dataset.orders`;
```

## Data Versioning

### DVC (Data Version Control)
```bash
# Initialize DVC
dvc init

# Track data
dvc add data/train.csv
git add data/train.csv.dvc .gitignore
git commit -m "Add training data"

# Push to remote storage
dvc remote add -d storage gs://bucket/dvc-storage
dvc push

# Pull specific version
git checkout v1.0
dvc pull
```

### Dataset Versioning in Vertex AI
```python
# Create versioned dataset
dataset_v1 = aiplatform.TabularDataset.create(
    display_name='customer-churn-v1',
    gcs_source='gs://bucket/data_v1.csv'
)

dataset_v2 = aiplatform.TabularDataset.create(
    display_name='customer-churn-v2',
    gcs_source='gs://bucket/data_v2.csv'
)

# Track lineage
dataset_v2.update(
    labels={'previous_version': dataset_v1.resource_name}
)
```

## Best Practices

### Data Quality
1. Validate data schemas
2. Check for missing values
3. Detect outliers
4. Monitor data drift
5. Document data sources
6. Version datasets
7. Implement data tests
8. Regular data audits

### Feature Engineering
1. Use Feature Store for consistency
2. Version features
3. Document feature definitions
4. Monitor feature distributions
5. Implement feature validation
6. Test feature importance
7. Automate feature pipelines
8. Cache expensive computations

### Data Pipelines
1. Make pipelines idempotent
2. Implement error handling
3. Monitor pipeline health
4. Version pipeline code
5. Test with sample data
6. Document dependencies
7. Optimize for cost
8. Enable reprocessing

## Study Tips

1. Practice feature engineering techniques
2. Work with Feature Store
3. Build data pipelines with Dataflow
4. Use BigQuery for feature aggregation
5. Implement data validation
6. Version datasets properly
7. Monitor data quality

## Additional Resources

- [Feature Store Documentation](https://cloud.google.com/vertex-ai/docs/featurestore)
- [TensorFlow Data Validation](https://www.tensorflow.org/tfx/data_validation)
- [Dataflow for ML](https://cloud.google.com/architecture/ml-inference-serving-patterns)
- [BigQuery for ML](https://cloud.google.com/bigquery/docs/bigqueryml-intro)
