# Projeto de Análise de Dados COVID-19

## Descrição
Este projeto contém uma análise detalhada dos dados de COVID-19, incluindo casos, mortes e vacinação em diferentes países e continentes. O objetivo é fornecer insights valiosos sobre a progressão da pandemia e os esforços de vacinação.

## Estrutura do Repositório
- `data/`: Contém os arquivos de dados brutos e processados.
- `scripts/`: Scripts SQL usados para consultas e transformação de dados.
- `reports/`: Relatórios gerados a partir da análise.

## Conjunto de Dados
Os dados utilizados neste projeto foram extraídos de [Our World in Data](https://ourworldindata.org/covid-vaccinations). O conjunto de dados inclui informações sobre casos confirmados de COVID-19, mortes, e números de vacinação para diversos países ao redor do mundo.

## Ferramentas Utilizadas
- **SQL Server**: Para consultas e manipulação de dados.

## Instruções de Uso
1. Clone o repositório:
    ```sh
    git clone https://github.com/seu-usuario/nome-do-repositorio.git
    ```
2. Navegue até o diretório do projeto:
    ```sh
    cd nome-do-repositorio
    ```
3. Execute os notebooks para reproduzir a análise:
    ```sh
    jupyter notebook notebooks/
    ```

## Exemplos de Consultas SQL
Aqui está um exemplo de consulta SQL usada no projeto para calcular a soma acumulada de pessoas vacinadas por localização:
```sql
SELECT dea.continent, 
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations, 
       SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM portfolio_project_covid..CovidDeaths dea
JOIN portfolio_project_covid..CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
