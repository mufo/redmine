require File.expand_path('../../test_helper', __FILE__)

class OperationsControllerTest < ActionController::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers,
           :time_entries,
           :journals,
           :journal_details,
           :queries

    ActiveRecord::Fixtures.create_fixtures(Redmine::Plugin.find(:redmine_contacts).directory + '/test/fixtures/', 
                            [:contacts,
                             :contacts_projects,
                             :contacts_issues,
                             :deals,
                             :notes,
                             :roles,
                             :enabled_modules,
                             :tags,
                             :taggings,
                             :contacts_queries])   

    if RedmineFinance.invoices_plugin_installed?
      ActiveRecord::Fixtures.create_fixtures(Redmine::Plugin.find(:redmine_contacts_invoices).directory + '/test/fixtures/', 
                            [:invoices,
                             :invoice_lines])
    end

    ActiveRecord::Fixtures.create_fixtures(Redmine::Plugin.find(:redmine_finance).directory + '/test/fixtures/', 
                          [:accounts,
                           :operations,
                           :enabled_modules,
                           :operation_categories])

  def setup
    Project.find(1).enable_module!(:finance)
  end

  def test_should_get_index
    @request.session[:user_id] = 1
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:operations)
    assert_nil assigns(:project)  
  end

  def test_should_get_show
    @request.session[:user_id] = 1
    get :show, :id => 1
    assert_response :success
    assert_template :show
    assert_not_nil assigns(:operation)
    assert_not_nil assigns(:project)  
  end

  def test_should_get_new
    @request.session[:user_id] = 1
    get :new, :project_id => 1
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:operation)
    assert_not_nil assigns(:project)  
  end  

  def test_should_get_edit
    @request.session[:user_id] = 1
    get :edit, :id => 1
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:operation)
    assert_not_nil assigns(:project)  
  end  

  def test_should_put_update
    @request.session[:user_id] = 1
    put :update, :id => 1, :operation => {:amount => 99.9}
    assert_response :redirect
    assert_equal 99.9, Operation.find(1).amount
  end   

  def test_should_post_create
    @request.session[:user_id] = 1
    post :create, :project_id => 1, :operation => {:description => "New operation description", 
        :account_id => 1,
        :amount => 1000, 
        :category_id => 1, 
        :operation_date => Time.now}
    assert_response :redirect
    assert_equal 1030, Operation.last.account.amount
    assert_equal "New operation description", Operation.last.description
  end  

end
