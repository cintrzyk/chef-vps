set['rbenv']['rubies'] = %w( 2.1.5 )
set['rbenv']['global'] = '2.1.5'
set['rbenv']['gems'] = {
  '2.1.5' => [
    { name: 'bundler', version: '1.7.3' },
    { name: 'pry', version: '0.10.1' },
  ]
}
