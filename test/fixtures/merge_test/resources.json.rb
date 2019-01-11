# frozen_string_literal: true

{
  resources: merge(
    render('resource_a'),
    render('resource_b')
  )
}
