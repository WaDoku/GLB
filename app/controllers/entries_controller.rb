#encoding: utf-8
class EntriesController < ApplicationController
  # GET /entries
  # GET /entries.json
  before_filter :authenticate_user!
  def index
    params[:search] = nil if params[:search] and params[:search].strip == "" 
    @page = params[:page] || 0
    all_entries = (params[:search] ? Entry.search(params[:search]) : Entry).order("romaji_order")
    @count = all_entries.count
    @entries = all_entries.page(@page)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entries }
      format.csv {send_data @entries.to_csv, :type => 'text/csv', :disposition => "attachment; filename=glb.csv"}
      format.xml {send_data Entry.find(:all).to_xml, :type => 'text/xml', :disposition => "attachment; filename=glb.xml"}
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = Entry.find(params[:id])
    @comment = Comment.new
    @comment.entry = @entry
    @comment.user = current_user

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = Entry.new
    if current_user.role == "admin"
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @entry }
      end
    else
      flash[:notice] = 'Sie dürfen keine neuen Einträge erstellen.'
      redirect_to :action => 'index'
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])
    if @entry.user != current_user && current_user.role != "admin"
      flash[:notice] = "Sie dürfen die Einträge von anderen Mitarbeitern nicht bearbeiten. Hinterlassen Sie stattdessen einen Kommentar."
      redirect_to :action => 'show'
    end
  end

  # POST /entries
  # POST /entries.json
  def create
    @verfasser = User.find(params[:entry].delete('user_id'))
    params[:entry].delete("freigeschaltet")
    @entry = Entry.new(params[:entry])
    @entry.user = @verfasser

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Eintrag erfolgreich erstellt.' }
        format.json { render json: @entry, status: :created, location: @entry }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.json
  def update
    @entry = Entry.find(params[:id])
    if current_user.role == 'admin'
      @verfasser = User.find(params[:entry].delete('user_id'))
      @entry.user = @verfasser
    end
    
    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        format.html { redirect_to @entry, notice: "Eintrag erfolgreich gespeichert. #{undo_link}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url, notice: "Eintrag erfolgreich gelöscht. #{undo_link}" }
      format.json { head :no_content }
    end
  end

  private
  def undo_link
    view_context.link_to("Rückgängig", revert_version_path(@entry.versions.scoped.last), :method => :post)
  end

end
