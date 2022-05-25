# frozen_string_literal: true

class Memo
  JSON_PATH = 'db/memo.json'
  class << self
    def all
      File.open(JSON_PATH, 'w') { |file| file << [] } unless FileTest.exist?(JSON_PATH)
      JSON.parse(File.read(JSON_PATH), symbolize_names: true)
    end

    def create(params)
      memos = all
      params[:id] = SecureRandom.uuid
      memos << params
      write(memos)
    end

    def update(params)
      memos = all
      target_memo = memos.find { |memo| memo[:id] == params[:id] }
      target_memo[:title] = params[:title]
      target_memo[:content] = params[:content]
      write(memos)
    end

    def delete(id)
      memos = all
      memos.delete_if { |memo| memo[:id] == id }
      write(memos)
    end

    def write(memos)
      File.open(JSON_PATH, 'w') { |file| JSON.dump(memos, file) }
    end

    def find(id)
      all.find { |file| file[:id] == id }
    end
  end
end
