## UFC Fighter Intelligence Platform

Performance Scoring & Market Valuation Analysis

A end-to-end data analytics project analysing 7,177 historical UFC bouts to build a fighter valuation model that compares performance-based scores against betting market implied probabilities to identify which fighters are undervalued or overvalued by the market.

**[Live Interactive Tableau Dashboard](https://public.tableau.com/views/UFCMarketValuationFighterPerformanceAnalyticsDashboard/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**

![UFC Dashboard Preview](UFC%20Tableau%20Dashboard.png)

---

## The Problem
UFC betting markets price fighters based on reputation, hype, and public perception. But does the market price actually reflect how well a fighter performs? This project builds a data-driven answer that scores every fighter on measurable performance metrics using different KPI's and comparing that score against what the betting market says they're worth.

---

## Business Questions

- Which UFC fighters are consistently undervalued by the betting market relative to their actual        performance?
- Which weight classes produce the most finishes — and which ones go the distance most often?
- How accurately does the UFC betting market price fighter talent across 7,000+ historical bouts?
- What does the distribution of over and undervalued fighters look like across the entire roster?

---

## Key Findings

**Heavyweight and Light Heavyweight** are the most exciting divisions with finish rates of **61.7%** and **61.3%** respectively. This means that over 6 in 10 fights end before the judges' scorecards.

* **Women's divisions** finish far fewer fights. Women's Featherweight (**33.3%**) and Women's Strawweight (**32.6%**) go to the judges most often.
  
* **197 fighters** are deeply overvalued by betting markets relative to their actual performance score.
  
* **82 fighters** are significantly undervalued and are performing well above what the market prices them at, representing potential inefficiencies in how the market values fighters.

* **519 fighters** are fairly valued. The market prices the majority of fighters accurately, but meaningful mispricings exist at the extremes.
  
* **Lightweight** is the most active division with **1,160** recorded bouts which is nearly double the Heavyweight division (541).

---

## Tools and Methodology

| Tool | Purpose |
|------|---------|
| Microsoft Excel | Initial data exploration, column profiling, and identifying data quality issues before loading into SQL |
| SQL Server | Data cleaning, feature engineering, valuation model, analytical queries |
| Tableau | Interactive dashboard and data visualisations |

Excel was used first to understand the raw structure of both datasets before any transformation. SQL handled all the heavy analytical work — cleaning, modelling, and querying across 7,177 fights. Tableau translated the SQL output into a visual story that communicates findings without needing to read a single line of code.

**Fighter Performance Score** is a composite metric built from two components:
- **Win Rate Score (0–50 pts)** — scales a fighter's win percentage to a maximum of 50 points
- **Striking Score (0–50 pts)** — scales a fighter's average significant strike differential against opponents to a maximum of 50 points

**Market Price Percentage** converts UFC moneyline betting odds into an implied win probability using standard odds conversion formulas:
- Favourite: `|odds| / (|odds| + 100) × 100`
- Underdog: `100 / (odds + 100) × 100`

**Valuation Gap** = Fighter Performance Score − Market Price Percentage. Positive values indicate undervaluation; negative values indicate overvaluation.

---

## SQL Queries

| Query | Business Question |
|-------|------------------|
| Data cleaning | Handle NULL values, remove whitespace, standardise columns |
| `v_FighterValuationModel` (View) | Core valuation model combining win score, striking score, and market price |
| Top 15 Undervalued Fighters | Which fighters outperform their market price the most? |
| Top 15 Overvalued Fighters | Which fighters underperform relative to their market price? |
| Finish Rate by Weight Class | Which divisions produce the most finishes vs decisions? |
| Valuation Tier Distribution | How are fighters distributed across valuation tiers? |

---

## Dashboard

The Tableau dashboard contains 6 interactive views:

1. **Market Valuation Spread** — scatter plot of every fighter's performance score vs market price, colour coded by valuation tier
2. **Top 15 Undervalued Fighters** — horizontal bar chart ranked by valuation gap
3. **Top 15 Overvalued Fighters** — horizontal bar chart ranked by overvaluation gap
4. **Division Finish Percentages** — treemap showing finish rates across all UFC weight classes
5. **Valuation Tier Distribution** — breakdown of how many fighters fall into each valuation category
6. **Total Fights by Division** — fight volume across all divisions

**[View Live Dashboard](https://public.tableau.com/views/UFCMarketValuationFighterPerformanceAnalyticsDashboard/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**

---

## Project Structure

```
ufc-fighter-intelligence-platform/
│
├── ufc_analytics.sql        # All SQL — cleaning, view, analytical queries and Tableau queries
├── dashboard_preview.png    # Dashboard screenshot
└── README.md
```

---

## About

Built by **Davon Shyu** - Mathematics specialist in Statistics at the University of Toronto, passionate about turning raw data into actionable insights.

[LinkedIn](https://linkedin.com/in/davon-shyu) | [Tableau Public](https://public.tableau.com/app/profile/davon.shyu/vizzes)

---

## Data


**[Source: Kaggle — UFC Fights Historical Dataset](https://www.kaggle.com/datasets/mdabbert/ultimate-ufc-dataset)**

**[Source: Kaggle — UFC Fighters Dataset](https://www.kaggle.com/datasets/asaniczka/ufc-fighters-statistics)**
