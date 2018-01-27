class AssignmentsController < ApplicationController
  load_and_authorize_resource

  def new
    @assignment = Assignment.new(creator_id: current_user.id, entry_id: params['entry_id'])
  end

  def edit
  end

  def create
    @assignment = Assignment.new(assignment_params.merge({to_date: calc_expiry_date}))
    if @assignment.save
      redirect_to user_entries_path(@assignment.recipient_id), notice: 'Die Zuweisung wurde erfolgreich erstellt.'
      AssignmentNotifier.create(@assignment).deliver_now
    else
      render :new
    end
  end

  def update
    if @assignment.update(assignment_params.merge({to_date: calc_expiry_date}))
      redirect_to user_entries_path(@assignment.recipient_id), notice: 'Die Zuweisung wurde erfolgreich bearbeitet.'
      AssignmentNotifier.create(@assignment).deliver_now
    else
      render :edit
    end
  end

  def destroy
    assignment_recipient = @assignment.recipient_id
    if @assignment.destroy
      redirect_to user_entries_path(assignment_recipient), notice: 'Der Eintrag wurde mit erledigt markiert.'
      AssignmentNotifier.done(@assignment).deliver_now
    else
      redirect_to user_entries_path(assignment_recipient), notice: 'Die Zuweisung konnte nicht gelöscht werden.'
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def assignment_params
    params.require(:assignment).permit(:creator_id, :recipient_id, :from_date, :to_date, :entry_id)
  end

  def calc_expiry_date
    Date.today + (assignment_params[:to_date].to_i).month
  end

end
