# frozen_string_literal: true

class Memo
  JSON_PATH = 'db/memo.json'

  def self.all
    File.open(JSON_PATH, 'w') unless FileTest.exist?(JSON_PATH)
    read.empty? ? [] : convert_json
  end

  def self.create(memo_params)
    memos = all
    memo_params[:id] = SecureRandom.uuid
    memos << memo_params
    write(memos)
  end

  def self.update(memo_params)
    memos = all
    memos.each do |memo|
      if memo[:id] == memo_params[:id]
        memo[:title] = memo_params[:title]
        memo[:contents] = memo_params[:contents]
      end
    end
    Memo.write(memos)
  end

  def self.delete(memo_params)
    memos = all
    memos.delete_if { |memo| memo[:id] == memo_params[:id] }
    Memo.write(memos)
  end

  def self.read
    File.read(JSON_PATH)
  end

  def self.convert_json
    JSON.parse(read, symbolize_names: true)
  end

  def self.write(memos)
    File.open(JSON_PATH, 'w') { |file| JSON.dump(memos, file) }
  end

  def self.find(id)
    convert_json.find { |file| file[:id] == id[:id] }
  end
end
