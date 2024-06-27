select distinct top 100 (I_PRODUCT_NAME)
from item i1
where I_MANUFACT_ID between 749 and 749 + 40
  and (
    select count(*) as item_cnt
    from item
    where (
        I_MANUFACT = i1.I_MANUFACT
        and (
          (
            I_CATEGORY = 'Women'
            and (
              I_COLOR = 'rose'
              or I_COLOR = 'aquamarine'
            )
            and (
              I_UNITS = 'Dram'
              or I_UNITS = 'Oz'
            )
            and (
              I_SIZE = 'petite'
              or I_SIZE = 'small'
            )
          )
          or (
            I_CATEGORY = 'Women'
            and (
              I_COLOR = 'antique'
              or I_COLOR = 'bisque'
            )
            and (
              I_UNITS = 'N/A'
              or I_UNITS = 'Gram'
            )
            and (
              I_SIZE = 'extra large'
              or I_SIZE = 'economy'
            )
          )
          or (
            I_CATEGORY = 'Men'
            and (
              I_COLOR = 'drab'
              or I_COLOR = 'pink'
            )
            and (
              I_UNITS = 'Pallet'
              or I_UNITS = 'Bunch'
            )
            and (
              I_SIZE = 'large'
              or I_SIZE = 'N/A'
            )
          )
          or (
            I_CATEGORY = 'Men'
            and (
              I_COLOR = 'khaki'
              or I_COLOR = 'peach'
            )
            and (
              I_UNITS = 'Bundle'
              or I_UNITS = 'Gross'
            )
            and (
              I_SIZE = 'petite'
              or I_SIZE = 'small'
            )
          )
        )
      )
      or (
        I_MANUFACT = i1.I_MANUFACT
        and (
          (
            I_CATEGORY = 'Women'
            and (
              I_COLOR = 'steel'
              or I_COLOR = 'hot'
            )
            and (
              I_UNITS = 'Case'
              or I_UNITS = 'Tsp'
            )
            and (
              I_SIZE = 'petite'
              or I_SIZE = 'small'
            )
          )
          or (
            I_CATEGORY = 'Women'
            and (
              I_COLOR = 'burnished'
              or I_COLOR = 'cream'
            )
            and (
              I_UNITS = 'Unknown'
              or I_UNITS = 'Ton'
            )
            and (
              I_SIZE = 'extra large'
              or I_SIZE = 'economy'
            )
          )
          or (
            I_CATEGORY = 'Men'
            and (
              I_COLOR = 'slate'
              or I_COLOR = 'seashell'
            )
            and (
              I_UNITS = 'Lb'
              or I_UNITS = 'Box'
            )
            and (
              I_SIZE = 'large'
              or I_SIZE = 'N/A'
            )
          )
          or (
            I_CATEGORY = 'Men'
            and (
              I_COLOR = 'white'
              or I_COLOR = 'salmon'
            )
            and (
              I_UNITS = 'Pound'
              or I_UNITS = 'Cup'
            )
            and (
              I_SIZE = 'petite'
              or I_SIZE = 'small'
            )
          )
        )
      )
  ) > 0
order by I_PRODUCT_NAME option (label = 'TPCDS-Q41');