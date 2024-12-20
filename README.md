# **COVID-19 Data Analysis and Visualization**

[🚀 Explore the Interactive Tableau Dashboard](https://public.tableau.com/app/profile/burak.sener/viz/CovidDashboard_16881199622700/Dashboard1)  
**✨ Discover insights with an interactive experience!**

## **Overview**
This project demonstrates my expertise in data analysis, SQL, and Tableau by exploring global COVID-19 trends. I combined advanced SQL techniques with compelling Tableau visualizations to uncover meaningful insights from a complex dataset sourced from the **World Health Organization (WHO)**.

---

## **Objective**
To showcase my skills in:
- **🛠️ SQL**: Writing efficient queries to analyze and clean real-world datasets.
- **📊 Data Storytelling**: Creating interactive Tableau dashboards to present insights effectively.
- **🧠 Problem-Solving**: Addressing real-world questions about COVID-19 trends through data-driven approaches.

---

## **Skills Demonstrated**
1. **🧹 Data Cleaning**:
   - Filtered and refined data to remove inconsistencies (e.g., null continents) and improve accuracy.
2. **⚙️ Advanced SQL**:
   - Used CTEs, joins, temporary tables, and window functions for in-depth analysis.
3. **📈 Data Visualization**:
   - Designed an interactive Tableau dashboard with global and regional trends.
4. **🔍 Critical Thinking**:
   - Explored relationships between variables like population, cases, deaths, and vaccination rates.

---

## **Key Features**

### **SQL Analysis**
- Extracted critical insights, including:
  - 📉 Death rates as a percentage of total cases.
  - 🌍 Infection rates relative to population size.
  - 💉 Vaccination progress and its impact on infection and death trends.
  
  
#### Example Query: Population Vaccination Progress
```sql
WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated) AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.Date)
AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ AS dea 
INNER JOIN PortfolioProject..CovidVaccinations$ AS vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated / Population) * 100 AS Percent_Population_Vaccinated
FROM PopvsVac
ORDER BY Percent_Population_Vaccinated DESC;
```

### **Tableau Dashboard**
[📊 Explore the Interactive Dashboard](https://public.tableau.com/app/profile/burak.sener/viz/CovidDashboard_16881199622700/Dashboard1)

[The dashboard](https://public.tableau.com/app/profile/burak.sener/viz/CovidDashboard_16881199622700/Dashboard1) includes:
- **🗺️ Global Heatmaps**: Visualizes infection and death rates by region.
- **📉 Trend Charts**: Tracks daily and cumulative data for cases, deaths, and vaccinations.
- **🔎 Country-Level Insights**: Drill-down features for specific nations.

---

## **Data Source**
- **🌐 World Health Organization (WHO)**: The primary dataset provider, ensuring accuracy and reliability.

---

## **Achievements**
- 🛠️ Automated data integration with SQL to clean, aggregate, and analyze COVID-19 statistics.
- 📊 Designed a user-friendly Tableau dashboard to communicate findings clearly.
- 📖 Gained valuable insights into pandemic trends and their implications.

---

If you liked this project or want to discuss anything tech-related, feel free to connect with me:

- 🌐 **Website**: [buraksener.com](https://buraksener.com)
- 💼 **LinkedIn**: [Burak Sener](https://www.linkedin.com/in/burakssener)
