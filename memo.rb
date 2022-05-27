# frozen_string_literal: true

class Memo
  JSON_PATH = 'db/memo.json'
  class << self
    def all
      memos = []
      conn = PG.connect(dbname: 'memoapp')
      conn.exec('SELECT * FROM memos') do |result|
        result.each { |row| memos << row }
      end
      memos
    end

    def create(params)
      conn = PG.connect(dbname: 'memoapp')
      conn.exec_params('INSERT INTO memos (id, title, content) VALUES ($1, $2, $3)', [SecureRandom.uuid, params[:title], params[:content]])
    end

    def update(params)
      conn = PG.connect(dbname: 'memoapp')
      conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [params[:title], params[:content], params[:id]])
    end

    def delete(id)
      conn = PG.connect(dbname: 'memoapp')
      conn.exec_params('DELETE FROM memos WHERE id = $1', [id])
    end

    def find(id)
      all.find { |file| file['id'] == id }
    end
  end
end
