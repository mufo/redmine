module OperationsHelper
  include DealsHelper

  def operation_categories_for_select(selected = nil)
    operation_categories = OperationCategory.order("#{OperationCategory.table_name}.is_income DESC").order(:position)
    return "" unless operation_categories.any?
    previous_group = operation_categories.first.is_income?
    s = "<optgroup label=\"#{ERB::Util.html_escape(operation_categories.first.is_income? ? l(:label_operation_income) : l(:label_operation_expense))}\">".html_safe
    operation_categories.each do |category|
      if category.is_income? != previous_group
        reset_cycle
        s << '</optgroup>'.html_safe
        s << "<optgroup label=\"#{ERB::Util.html_escape(category.is_income? ? l(:label_operation_income) : l(:label_operation_expense))}\">".html_safe
        previous_group = category.is_income?
      end
      s << %Q(<option #{'selected="selected"' if category.id == selected.to_i} value="#{ERB::Util.html_escape(category.id)}">#{ERB::Util.html_escape(category.name)}</option>).html_safe
    end
    s << '</optgroup>'
    s.html_safe
  end 


  def accounts_for_select
    scope = @project ? @project.accounts : Account.scoped({})
    scope.all.map{|a| ["#{a.name} (#{a.currency})", a.id]}
  end

  def operations_sum_to_currency(operations_sum)
    operations_sum.map{|c| price_to_currency(c[1].to_f, c[0])}.join('<br/>').html_safe  
  end  

  def operations_balance_to_currency(income_sum, expense_sum)
    currencies = income_sum.map{|a| a[0]} | expense_sum.map{|a| a[0]}
    currencies.map{|a| price_to_currency(income_sum[a].to_f - expense_sum[a].to_f, a)}.join('<br/>').html_safe  
    # operations_balance.map{|c| c[0][1].to_i - c[1][1].to_f}
  end

  def operations_to_csv(operations)
    decimal_separator = l(:general_csv_decimal_separator)
    encoding = l(:general_csv_encoding)
    export = FCSV.generate(:col_sep => l(:general_csv_separator)) do |csv|
      # csv header fields
      headers = [ "#",
                  'Operation date',
                  'Income',
                  'Expense',
                  'Operation type',
                  'Account',
                  'Description',
                  'Contact',
                  'Created',
                  'Updated'
                  ]
      custom_fields = OperationCustomField.all
      custom_fields.each {|f| headers << f.name}
      # Description in the last column
      csv << headers.collect {|c| Redmine::CodesetUtil.from_utf8(c.to_s, encoding) }
      # csv lines
      operations.each do |operation|
        fields = [operation.id,
                  format_date(operation.operation_date),
                  operation.is_income? ? operation.amount : "",
                  operation.is_income? ? "" :  operation.amount,
                  operation.category_name,
                  operation.account.name,
                  operation.description,
                  !operation.contact.blank? ? "##{operation.contact.id}: #{operation.contact.name}" : '',
                  format_date(operation.created_at),
                  format_date(operation.updated_at)
                  ]
        custom_fields.each {|f| fields << show_value(operation.custom_value_for(f)) }
        csv << fields.collect {|c| Redmine::CodesetUtil.from_utf8(c.to_s, encoding) }
      end
    end
    export
  end  

end
