La captura de tweets es toda en un mismo día: hallar el hashtag más utilizado en
cada hora del día.

db.tweets.aggregate([
    {$group: {$hour: "$date"}}
])

{
  _id: '1143670209296785408',
  created_at: 2019-06-26T00:00:00.000Z,
  full_text: '#Política El gobierno le aseguró a inversores que después de las elecciones avanzará con la reforma laboral\n' +
    'https://t.co/8WW9thmUW0 https://t.co/KlzmEbMluR',
  truncated: false,
  display_text_range: [
    0,
    131
  ],
  entities: {
    hashtags: [
      {
        text: 'Política',
        indices: [
          0,
          9
        ]
      }
    ],
    symbols: [],
    user_mentions: [],
    urls: [
      {
        url: 'https://t.co/8WW9thmUW0',
        expanded_url: 'http://somosjujuy.com.ar/politica/80294-el-gobierno-le-aseguro-a-inversores-que-despues-de-las-elecciones-avanzara-con-la-reforma-laboral',
        display_url: 'somosjujuy.com.ar/politica/80294…',
        indices: [
          108,
          131
        ]
      }
    ],
    media: [
      {
        id: 1143641536908943400,
        id_str: '1143641536908943362',
        indices: [
          132,
          155
        ],
        media_url: 'http://pbs.twimg.com/media/D98H6yXW4AIX-MJ.jpg',
        media_url_https: 'https://pbs.twimg.com/media/D98H6yXW4AIX-MJ.jpg',
        url: 'https://t.co/KlzmEbMluR',
        display_url: 'pic.twitter.com/KlzmEbMluR',
        expanded_url: 'https://twitter.com/SomosJujuy/status/1143670209296785408/photo/1',
        type: 'photo',
        sizes: {
          large: {
            w: 990,
            h: 610,
            resize: 'fit'
          },
          thumb: {
            w: 150,
            h: 150,
            resize: 'crop'
          },
          medium: {
            w: 990,
            h: 610,
            resize: 'fit'
          },
          small: {
            w: 680,
            h: 419,
            resize: 'fit'
          }
        }
      }
    ]
  },
  source: '<a href="https://about.twitter.com/products/tweetdeck" rel="nofollow">TweetDeck</a>',
  in_reply_to_status_id: null,
  in_reply_to_status_id_str: null,
  in_reply_to_user_id: null,
  in_reply_to_user_id_str: null,
  in_reply_to_screen_name: null,
  user: {
    id_str: '3377502832',
    name: 'SomosJujuy',
    screen_name: 'SomosJujuy',
    location: 'Jujuy, Argentina',
    description: 'Noticias las 24 horas. Toda la información local, nacional e internacional.',
    url: 'http://t.co/azDa2Wrbsd',
    protected: false,
    followers_count: 4627,
    friends_count: 301,
    listed_count: 71,
    created_at: 'Wed Jul 15 15:34:31 +0000 2015',
    favourites_count: 264,
    time_zone: null,
    verified: false,
    statuses_count: 55915,
    lang: null,
    default_profile: false
  },
  geo: null,
  coordinates: null,
  place: null,
  contributors: null,
  is_quote_status: false,
  retweet_count: 0,
  favorite_count: 0,
  possibly_sensitive: false,
  lang: 'es',
  text: '#Política El gobierno le aseguró a inversores que después de las elecciones avanzará con la reforma laboral\n' +
    'https://t.co/8WW9thmUW0 https://t.co/KlzmEbMluR',
  user_id: '3377502832',
  in_user_hashtag_collection: true,
  hashtag_origin_checked: true,
  cooccurrence_checked: true
}