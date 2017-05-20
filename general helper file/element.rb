    #
    # Marks (checkmark) element.
    #
    # @example
    #   browser.text_field(name: "new_user_first_name").checkmark
    #
    def checkmark
          driver.execute_script("arguments[0].before('-')", @element)
          driver.execute_script("arguments[0].after('-')", @element)
          driver.execute_script("arguments[0].append('-')", @element)
          driver.execute_script("arguments[0].prepend('-')", @element)
            self
    end

    def highlight
      color = "rgba(255, 255, 66, 0.6)"
      shadow = "5px 5px 10px 0px rgba(0, 0, 0, .3)"
      driver.execute_script("arguments[0].style.boxShadow = '#{shadow}'", @element)
      driver.execute_script("arguments[0].style.backgroundColor = '#{color}'", @element)
      self
    end