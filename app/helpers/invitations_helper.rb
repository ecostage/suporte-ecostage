module InvitationsHelper
  def comming_from_group_path?
    !!group_id
  end

  def group_id
    $1 if %r[http://.+?/groups/(\d+)$] =~ request.referrer
  end
end
