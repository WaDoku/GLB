shared_examples_for 'every user can access' do
  context 'as admin' do
    before do
      sign_in admin
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as editor' do
    before do
      sign_in editor
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as author' do
    before do
      sign_in author
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as commentator' do # ?
    before do
      sign_in commentator
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as guest' do
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
end

shared_examples_for 'something that admin, editor & author can access' do
  context 'as admin' do
    before do
      sign_in admin
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as editor' do
    before do
      sign_in editor
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as author' do
    before do
      sign_in author
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
end

shared_examples_for 'something that admin & editor can access' do
  context 'as admin' do
    before do
      sign_in admin
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as editor' do
    before do
      sign_in editor
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as author' do
    before do
      sign_in author
    end
    it 'is not accessible' do
      subject
      expect(response).not_to be_success
    end
  end
  context 'as commentator' do
    before do
      sign_in commentator
    end
    it 'is not accessible' do
      subject
      expect(response).not_to be_success
    end
  end
end

shared_examples_for 'something that only admin can access' do
  context 'as editor' do
    before do
      sign_in editor
    end
    it 'redirects' do
      subject
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Zugriff verwehrt')
    end
  end
  context 'as author' do
    before do
      sign_in author
    end
    it 'redirects' do
      subject
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Zugriff verwehrt')
    end
  end
  context 'as commentator' do
    before do
      sign_in commentator
    end
    it 'redirects' do
      subject
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Zugriff verwehrt')
    end
  end
  context 'as guest' do
    it 'redirects' do
      subject
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Zugriff verwehrt')
    end
  end
end

shared_examples_for 'something that commentator and guest can not access' do
  context 'as commentator' do
    before do
      sign_in commentator
    end
    it 'redirects' do
      subject
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Zugriff verwehrt')
    end
  end
  context 'as guest' do
    it 'redirects' do
      subject
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Zugriff verwehrt')
    end
  end
end
