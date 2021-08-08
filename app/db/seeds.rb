Client.delete_all

Client.create!(
  first_name: 'Super',
  last_name: 'Admin',
  email: 'super.admin@remastered.com',
  password: 'secret123',
  role: 'superadmin'
)

p 'Seed was executed successfully'