with source as (
        select * from read_csv({{ source('gtfs', 'shapes') }}, types = {'shape_id': 'string'})
)
    select
        *
    from source
    