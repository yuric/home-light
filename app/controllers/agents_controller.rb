class AgentsController < ApplicationController
  def show
    @agent = Agent.find(params[:id])
    @uploaded_transactions = @agent.all_transactions.paginate(:page => params[:page], :per_page => 4)
    respond_to do |format|
      format.html
      format.csv { send_data @uploaded_transactions.to_csv, filename: "TRANSACTIONS-#{Date.today}.csv" }
    end
  end

  def random_agent
    redirect_to agent_path(Agent.all.sample)
  end
  
end

# @uploaded_transactions = @agent.all_transactions
# UploadedTransaction.attribute_names