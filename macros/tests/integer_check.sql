
{% test integer_check(model, column_name) %}
SELECT *
FROM {{ model }}
WHERE {{ column_name }}::TEXT !~ '^\d+$'
{% endtest %}