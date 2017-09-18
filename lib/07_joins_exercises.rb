# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
  SELECT
    title
  FROM
  movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    actors.name = 'Harrison Ford'

  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
  SELECT
  title
  FROM movies
  JOIN
  castings ON movies.id = castings.movie_id
  JOIN
  actors on castings.actor_id = actors.id
  where
  actors.name = 'Harrison Ford' and ord > 1
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
  SELECT
  title, name
  from movies
  join
  castings on movies.id = castings.movie_id
  join
  actors on castings.actor_id = actors.id
  where
  yr = 1962 and ord = 1
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
  SELECT
  yr, count(title)
  from
  movies
  join
  castings on movies.id = castings.movie_id
  join
  actors on castings.actor_id = actors.id
  where name = 'John Travolta'
  group by yr
  having count(title) > 1

  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
  SELECT
  title, name
  FROM
  movies
  join castings on castings.movie_id = movies.id
  join actors on actors.id = castings.actor_id
  WHERE castings.movie_id IN (SELECT
  movie_id
  FROM
  movies
  join castings on castings.movie_id = movies.id
  join actors on actors.id = castings.actor_id
  WHERE
  name = 'Julie Andrews') AND ord = 1

  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
  SELECT
  name
  from
  movies
  join castings on movies.id = castings.movie_id
  join actors on castings.actor_id = actors.id
  WHERE
  ord = 1
  GROUP BY
  actors.name
  HAVING
  COUNT(title) >= 15
  ORDER BY
  actors.name ASC

  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
  -- SELECT
  -- title
  -- from movies
  -- where movies.id IN (
  --   SELECT
  --   movie_id, COUNT(actor_id) as actors_count
  --   from
  --   castings
  --   join movies on movies.id = castings.movie_id
  --   where yr = 1978
  --   group by movie_id
  --   order by COUNT(actor_id))



  SELECT
  title, COUNT(actor_id) as actors_count
  from
  castings
  join movies on movies.id = castings.movie_id
  where yr = 1978
  group by title
  order by COUNT(actor_id) DESC, title ASC



  -- ORDER BY
  -- COUNT(castings.actor_id) DESC, title ASC

  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
  SELECT
    DISTINCT name
  from
    actors
  join castings on castings.actor_id = actors.id
  where castings.movie_id IN (select movies.id
    from movies
    join castings on castings.movie_id = movies.id
    join actors on castings.actor_id = actors.id
    where name = 'Art Garfunkel') AND name != 'Art Garfunkel'

  -- SELECT
  --   *
  -- FROM
  --   actors AS actors1
  -- JOIN
  --   castings AS castings1 ON actors1.id = castings1.actor_id
  -- JOIN
  --   movies ON movies.id = castings1.movie_id
  -- JOIN
  --   castings AS castings2 ON movies.id = castings2.movie_id
  -- JOIN
  --   actors AS actors2 ON actors2.id = castings2.actor_id
  -- WHERE
  --   actors1.name = 'Art Garfunkel' AND actors2.name != 'Art Garfunkel'
  SQL
end
