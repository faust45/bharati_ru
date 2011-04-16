class Forum < BaseModel
  MAHARAJ_QUESTIONS = 'maharaj_questions'

  class <<self
    def section
      Thread.current[:section] || 'discussion'
    end

    def set_section(section)
      if section == 'maharaj_questions'
        Thread.current[:section] = 'maharaj_questions'
      end
    end

    def section_to_params
      section == "discussion" ? nil : section
    end
  end

end
