import pandas as pd

# Read raw age data
df = pd.read_csv("age-raw.csv")
pd.set_option('display.max_rows', None)

# Drop columns
df = df.drop(["date", "geography code", "Rural Urban"], axis=1)


# Rename age columns
renameMap = {}
for c in df :
    if "Age" in c:
        newName = c.split(":")[1].split(";")[0].strip()
        newName = newName.replace(" ", ".")
        renameMap[c] = newName
df = df.rename(columns=renameMap)

toPercentage = df[['Age.0.to.4', 'Age.5.to.7', 'Age.8.to.9', 'Age.10.to.14', 'Age.15', 'Age.16.to.17', 'Age.18.to.19', 'Age.20.to.24', 'Age.25.to.29', 'Age.30.to.44', 'Age.45.to.59', 'Age.60.to.64', 'Age.65.to.74', 'Age.75.to.84', 'Age.85.to.89', 'Age.90.and.over']]
x = []
for col in toPercentage:
    x.append("Percentage." + col)
    df["Percentage." + col] = (df[col] / df["All.usual.residents"]) * 100
df = df.drop(toPercentage, axis=1)

# Drop unnecessary columns such as under 18s
df = df.drop(["All.usual.residents", 'Percentage.Age.0.to.4', 'Percentage.Age.5.to.7', 'Percentage.Age.8.to.9', 'Percentage.Age.10.to.14', 'Percentage.Age.15', 'Percentage.Age.16.to.17'], axis=1)
# print(df[x].sum(axis=1))

df.to_csv("./age-formatted.csv", index=False)