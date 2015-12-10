module ACTV::Article::Authorable

  def author
    @author ||= author_from_reference || author_from_article
  end

  def by_line
    @by_line ||= description_by_type 'articleByLine'
  end

  def author_name_from_by_line
    author_name_regex = /by (.*)/i.match by_line
    author_name_regex[1].strip if author_name_regex.present?
  end

  private

  def author_from_article
    ACTV::Author.build_from_article self.to_hash
  end

  def author_from_reference
    if author_reference
      ACTV.asset(author_reference.id).first
    end
  rescue ACTV::Error::NotFound
    nil
  end

  def author_reference
    references.find { |reference| reference.type == "author" }
  end
end