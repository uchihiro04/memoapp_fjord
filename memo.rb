# frozen_string_literal: true

class Memo
  JSON_PATH = 'db/memo.json'
  class << self
    def all
      memos = []
      conn = PG.connect( dbname: 'memoapp' )
      conn.exec( "SELECT * FROM memos" ) do |result|
        result.each { |row|  memos << row }
      end
      memos
    end

    def create(params)
      conn = PG.connect( dbname: 'memoapp' )
      conn.exec( "INSERT INTO memos (id, title, content) VALUES ('#{SecureRandom.uuid}', '#{params[:title]}', '#{params[:content]}')" )
    end

    def update(params)
      conn = PG.connect( dbname: 'memoapp' )
      conn.exec( "UPDATE memos SET title = '#{params[:title]}', content = '#{params[:content]}' WHERE id = '#{params[:id]}'" )
    end

    def delete(id)
      conn = PG.connect( dbname: 'memoapp' )
      conn.exec( "DELETE FROM memos WHERE id = '#{id}'" )
    end

    def find(id)
      all.find { |file| file['id'] == id }
    end
  end
end
