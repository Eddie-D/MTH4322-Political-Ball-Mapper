import pandas as pd

df = pd.read_csv("./GE2010-results.csv")
pd.set_option('display.max_rows', None)

# Remove the Northern Irish rows:
oldLen = len(df)
df = (df[df["Region"] != "Northern Ireland"])
print(f"Removed: {oldLen - len(df)} constituencies")

keepColumns = ["Name", "Region", "Votes", "Con", "Lab", "LD"]

# Frame to sum
sf = df.drop(keepColumns, axis=1)

df = df[keepColumns]
df["Other"] = sf.sum(axis=1)
df.to_csv("./GE2010-Formatted.csv", index=False)