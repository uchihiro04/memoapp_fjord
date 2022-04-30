class Memo
  JSON_PATH = "db/memo.json"

  def initialize
  end

  def self.all
    File.open('db/memo.json', 'w') unless FileTest.exist?('db/memo.json')
    File.read('db/memo.json', 1).nil? ? [] : convert_json
  end

  def self.create(memo_params)
    memos = all
    memo_params[:id] = SecureRandom.uuid
    memos << memo_params
    write(memos)
  end

  def update
  end

  def delete
  end

  def self.find(id)
  end

  private
  def self.read
    File.read('db/memo.json')
  end

  def self.write(memos)
    File.open('db/memo.json', 'w') { |file| JSON.dump(memos, file) }
  end

  def self.convert_json
    JSON.parse(read, symbolize_names: true)
  end

  private_class_method :read, :convert_json, :write

end

=begin
クラスについて
・関係する処理を全部洗い出す
・メソッド名やレベルが合っているか確認
・パブリック/プライベートメソッドの確認
・インスタンスに対して呼びたいメソッド/インスタンスはないが呼ぶことでインスタンスを得たいメソッド（後者がクラスメソッド）
=end