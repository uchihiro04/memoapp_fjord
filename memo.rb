# frozen_string_literal: true

class Memo
  class << self
    def all
      memos = []
      connect_db.exec('SELECT * FROM memos ORDER BY created_at') do |result|
        result.each { |row| memos << row }
      end
      memos
    end

    def connect_db
      @connect_db ||= PG.connect(dbname: 'memoapp')
    end

    def create(params)
      connect_db.exec_params('INSERT INTO memos (title, content) VALUES ($1, $2)', [params[:title], params[:content]])
    end

    def update(params)
      connect_db.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [params[:title], params[:content], params[:id]])
    end

    def delete(id)
      connect_db.exec_params('DELETE FROM memos WHERE id = $1', [id])
    end

    def find(id)
      all.find { |file| file['id'] == id }
    end
  end
end
