import pandas as pd
import matplotlib.pyplot as plt

# Generate a sample large DataFrame (replace this with your actual DataFrame)
data = {
    'Column1': [1, 2, 3, 4, 5],
    'Column2': [10, 20, 30, 40, 50]
}

df = pd.DataFrame(data)

# Calculate summary statistics
summary = df.describe()

# Plot the summary view
fig, ax = plt.subplots()
summary.plot(kind='bar', ax=ax)
ax.set_title('Summary View of DataFrame')
ax.set_ylabel('Value')
plt.xticks(rotation=0)
plt.tight_layout()

plt.show()