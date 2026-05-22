import pandas as pd
from supabase import create_client

# CONEXÃO COM O SUPABASE
SUPABASE_URL = 'https://dafzthchjvglzrxjsewi.supabase.co'
SUPABASE_KEY = 'sb_publishable_GfbL_TckwcfpDwl9D1Y_AA_CDfYdNRL'
client = create_client(SUPABASE_URL, SUPABASE_KEY)

def rodar_analise():
    print("Iniciando análise de dados...")

    # ---------------------------------------------------
    # EXTRAÇÃO: Puxa dados brutos do banco
    # ---------------------------------------------------
    dados_custos = client.table('custos_extras').select('*').execute()
    dados_processos = client.table('processos').select('*').execute()
    
    # Transforma a resposta do Supabase em DataFrames do Pandas (tabelas do Python)
    df_custos = pd.DataFrame(dados_custos.data)
    df_processos = pd.DataFrame(dados_processos.data)

    # ---------------------------------------------------
    # TRANSFORMAÇÃO: Análise de dados com Python
    # ---------------------------------------------------
    # 1. Calcula o total absoluto de custos extras acumulados
    # Somamos todas as colunas de custo financeiro da sua tabela 'custos_extras'
    colunas_custo = ['avarias', 'lavagem_container', 'armazenagem', 'dta', 'demurrage_custo']
    total_custos_extras = df_custos[colunas_custo].sum().sum()

    # 2. Conta a quantidade total de processos ativos
    total_processos = len(df_processos)

    # 3. Média de custo de avarias por processo
    media_avarias = df_custos['avarias'].mean() if not df_custos.empty else 0

    # ---------------------------------------------------
    # CARGA: Salvamos os resultados na tabela kpi_dashboard)
    # ---------------------------------------------------
    # Lista com os resultados no formato que o banco espera
    indicadores = [
        {"chave": "total_custos_extras",
         "valor": float(total_custos_extras),
         "descricao": "Soma de todos os custos extras"},
        {"chave": "total_processos",
         "valor": float(total_processos),
         "descricao": "Quantidade total de processos"},
        {"chave": "media_avarias",
         "valor": float(media_avarias),
         "descricao": "Média gasta com avarias"}
    ]

    # O comando 'upsert' insere o dado ou atualiza se ele já existir
    for kpi in indicadores:
        client.table('kpis_dashboard').upsert(kpi).execute()

    print("Indicadores atualizados com sucesso no Supabase!")

if __name__ == "__main__":
    rodar_analise()