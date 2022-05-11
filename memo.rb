# frozen_string_literal: true

class Memo
  JSON_PATH = 'db/memo.json'
  class << self
    def all
      File.open(JSON_PATH, 'w') { |file| file << [] } unless FileTest.exist?(JSON_PATH)
      JSON.parse(File.read(JSON_PATH), symbolize_names: true)
    end

    def create(memo_params)
      memos = all
      memo_params[:id] = SecureRandom.uuid
      memos << memo_params
      write(memos)
    end

    def update(memo_params)
      memos = all
      memos.each do |memo|
        if memo[:id] == memo_params[:id]
          memo[:title] = memo_params[:title]
          memo[:content] = memo_params[:content]
        end
      end
      Memo.write(memos)
    end

    def delete(memo_params)
      memos = all
      memos.delete_if { |memo| memo[:id] == memo_params[:id] }
      Memo.write(memos)
    end

    def write(memos)
      File.open(JSON_PATH, 'w') { |file| JSON.dump(memos, file) }
    end

    def find(id)
      all.find { |file| file[:id] == id[:id] }
    end
  end
end
