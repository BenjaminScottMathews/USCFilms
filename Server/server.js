//server.js
var express = require('express');
const cors = require('cors');
const axios = require('axios');
const app = express();
const path = require('path');
app.use(cors());

//app.use(express.static('./dist/HW8AngApp'));
app.use(express.static('/assets'));

const mainURL = 'https://api.themoviedb.org/3';
const apiKey = '?api_key=ead4095417bb16d1d6607abf17bbebcf';
const lang = '&language=en-US';
const page = '&page=1';

/*
app.get('/', function (req, res)
{
	res.sendFile('dist/HW8AngApp/index.html');
});
*/

/* ------------------
	TYPEAHEAD ROUTE
   ------------------ */
app.get('/typeAhead/:keyword', function(req, res)
{
	var query = '&query=' + (req.params.keyword).replace(" ", "%20");
	var URL = `${mainURL}${'/search/multi'}${apiKey}${lang}${query}`;
	axios.get(URL)
	.then( response =>
	{
		var parsed_media = [];
		for (m of response.data.results)
		{
			if (parsed_media.length == 7)
				break;
			var curr_item = parseReslts(m);
			if (curr_item.id == null)
				continue;
			parsed_media.push(curr_item);
		}
		res.send(parsed_media);
	})
	.catch( error => {console.log(error)})
})

/* ------------------
  PLAYING MOVIES ROUTE
   ------------------ */
app.get('/playingMovies/', function(req, res)
{
	var URL = `${mainURL}${'/movie/now_playing'}${apiKey}${lang}${page}`;
	axios.get(URL)
	.then (response =>
	{
		var parsed_media = [];
		for (m of response.data.results)
		{
			if (parsed_media.length == 5)
				break;
			currMovie = {};
			currMovie['id'] = m.id;
            currMovie['type'] = "movie"
			if (m.id == null)
				continue;

			currMovie['title'] = (m.title != null) ? m.title : "No Title Found";
			currMovie['poster'] = (m.poster_path != null) ? ('https://image.tmdb.org/t/p/w500' + m.poster_path) : "https://uscfilms.ue.r.appspot.com/assets/movie_placeholder.png";
			if (m.poster_path == null)
				continue;
			parsed_media.push(currMovie);	
		}
		res.send(parsed_media);
	})
	.catch( error => {console.log(error)})
})

/* ------------------
  AIRING TV ROUTE
   ------------------ */
app.get('/airingTV', function(req, res)
{
    var URL = `${mainURL}${'/tv/airing_today'}${apiKey}${lang}${page}`;
    axios.get(URL)
    .then (response =>
    {
        var parsed_media = [];
        for (m of response.data.results)
        {
            if (parsed_media.length == 5)
                break;
            currMovie = {};
            currMovie['id'] = m.id;
            currMovie['type'] = "tv"
            if (m.id == null)
                continue;

            currMovie['title'] = (m.name != null) ? m.name : "No Title Found";
            currMovie['poster'] = (m.poster_path != null) ? ('https://image.tmdb.org/t/p/w500' + m.poster_path) : "https://uscfilms.ue.r.appspot.com/assets/movie_placeholder.png";
            if (m.poster_path == null)
                continue;
            parsed_media.push(currMovie);
        }
        res.send(parsed_media);
    })
    .catch( error => {console.log(error)})
})

app.get('/mediaReel/:type/:medium', function (req, res)
{
	switch (req.params.type)
	{
		case ("pop_movies"):
			var URL = `${mainURL}${'/movie/popular'}${apiKey}${lang}${page}`;
			break;
		case ("top_movies"):
			var URL = `${mainURL}${'/movie/top_rated'}${apiKey}${lang}${page}`;
			break;
		case ("trend_movies"):
			var URL = `${mainURL}${'/trending/movie/day'}${apiKey}`;
			break;
		case ("pop_tv"):
			var URL = `${mainURL}${'/tv/popular'}${apiKey}${lang}${page}`;
			break;
		case ("top_tv"):
			var URL = `${mainURL}${'/tv/top_rated'}${apiKey}${lang}${page}`;
			break;
		case ("trend_tv"):
			var URL = `${mainURL}${'/trending/tv/day'}${apiKey}`;
			break;
	}

	axios.get(URL)
	.then (response =>
	{
		var parsed_media = [];
		for (m of response.data.results)
		{
			if (parsed_media.length == 20)
				break;
			currMedia = {};
			currMedia['id'] = m.id;
			if (m.id == null)
				continue;

			if (req.params.medium == 'movies')
			{
				currMedia['title'] = (m.title != null) ? m.title : "No Title Found";
				currMedia['mediaType'] = 'movie';
                currMedia['date'] = (m.release_date != null) ? m.release_date.split('-', 1) : ['2000'];
			}
			else
			{
				currMedia['title'] = (m.name != null) ? m.name : "No Title Found";
				currMedia['mediaType'] = 'tv';
                currMedia['date'] = (m.first_air_date != null) ? m.first_air_date.split('-', 1) : ['2000'];
			}
			currMedia['poster'] = (m.poster_path != null) ? ('https://image.tmdb.org/t/p/w500' + m.poster_path) : "https://uscfilms.ue.r.appspot.com/assets/movie_placeholder.png";
			parsed_media.push(currMedia);	
		}
		res.send(parsed_media);
	})
	.catch( error => {console.log(error)})
})

/* ------------------
	 DETAILS ROUTE
   ------------------ */
app.get('/details/:type/:id', function (req, res)
{
	const query = `${'/'}${req.params.type}${'/'}${req.params.id}`;
	var detURL = `${mainURL}${query}${apiKey}${lang}${page}`;
	var vidURL = `${mainURL}${query}${'/videos'}${apiKey}${lang}${page}`;

	let fullDetails = {};
	axios.all([axios.get(detURL), axios.get(vidURL)])
	.then (axios.spread((rDets, rVid) =>
	{
		
		details = rDets.data;
		if (req.params.type == 'movie')
		{
			fullDetails['title'] = (details.title != null) ? details.title : "No Title Found";
			fullDetails['date'] = (details.release_date != null) ? details.release_date.split('-', 1) : 0;
			fullDetails['runtime'] = (details.runtime != null) ? details.runtime : 0;
		}
		else
		{
			fullDetails['title'] = (details.name != null) ? details.name : "No Title Found";
			fullDetails['date'] = (details.first_air_date != null) ? details.first_air_date.split('-', 1) : 0;
			fullDetails['runtime'] = (details.episode_run_time != null) ? details.episode_run_time : 0;
		}
		fullDetails['poster'] = (details.poster_path != null) ? ('https://image.tmdb.org/t/p/w500' + details.poster_path) : "https://uscfilms.ue.r.appspot.com/assets/movie_placeholder.png";
		fullDetails['genres'] = (details.genres != null) ? getGenres(details.genres) : 0;
		fullDetails['languages'] = (details.spoken_languages != null) ? getLanguages(details.spoken_languages) : 0;
		fullDetails['overview'] = (details.overview != null) ? details.overview : "No Overview Found";
		fullDetails['vote'] = (details.vote_average != null) ? ((details.vote_average)/10*5).toFixed(1) : "0";
		fullDetails['tagline'] = (details.tagline != null) ? details.tagline : "No Tagline Found";
        fullDetails['id'] = req.params.id

		video = rVid.data.results[0];
		if (video != undefined)
		{
			fullDetails['type'] = (video.type != null) ? video.type : "";
			fullDetails['caption'] = (video.name != null) ? video.name : "";
			fullDetails['vid_key'] = (video.key != null) ? video.key : 'tzkWB85ULJY'
			if (video.site == "YouTube")
				fullDetails['link'] = 'https://www.youtube.com/embed/' + fullDetails['vid_key'];
			else
				fullDetails['link'] = 'https://www.youtube.com/embed/tzkWB85ULJY';
		}
		else
			fullDetails['link'] = 'https://www.youtube.com/embed/tzkWB85ULJY';

		res.send(fullDetails);
	}))
	.catch( error => {console.log(error)})
});

/* ------------------
	   CAST ROUTE
   ------------------ */
app.get('/cast/:type/:id', function (req, res)
{
	const query = `${'/'}${req.params.type}${'/'}${req.params.id}`;
	var URL = `${mainURL}${query}${'/credits'}${apiKey}${lang}${page}`;

	let cast = [];
	axios.get(URL)
	.then (response =>
	{
		castData = response.data.cast;
		for (c of castData)
		{
			person = {};
			person['id'] = c.id;
			if (c.id == null)
				continue; 
			person['name'] = (c.name != null) ? c.name : "No Name Found";
			person['char'] = (c.character != null) ? c.character : "No Character Found";
			if (c.profile_path == null)
			{
				person = {};
				continue;
			}
			person['headshot'] = (c.profile_path != null) ? ('https://image.tmdb.org/t/p/w500/' + c.profile_path) : 'https://uscfilms.ue.r.appspot.com/assets/cast_placeholder.png';
			cast.push(person);
		}
		res.send(cast);
	})
	.catch( error => {console.log(error)})
});

/* ------------------
	  MODAL ROUTE
   ------------------ */
app.get('/person/:id', function (req, res)
{
	const query = `${'/person/'}${req.params.id}`;
	var URL = `${mainURL}${query}${apiKey}${lang}${page}`;
	var dURL = `${mainURL}${query}${'/external_ids'}${apiKey}${lang}${page}`;

	let person = {};

	axios.all([axios.get(URL), axios.get(dURL)])
	.then (axios.spread((resC, resD) =>
	{
		p = resC.data;
		person['birthday'] = (p.birthday != null) ? p.birthday : null;
		person['birthplace'] = (p.place_of_birth != null) ? p.place_of_birth : null; 
		person['gender'] = null;
		if (p.gender != null)
			person['gender'] = (p.gender==2) ? "Male" : "Female";
		person['name'] = (p.name != null) ? p.name : null;
		person['homepage'] = (p.homepage != null) ? p.homepage : null;
		person['AKA'] = (p.also_known_as != null) ? p.also_known_as : null;
		person['knownFor'] = (p.known_for_department != null) ? p.known_for_department : null;
		person['bio'] = (p.biography != null) ? p.biography : null;

		pD = resD.data;
		person['imdb'] = (pD.imdb_id != null) ? (`${'https://www.imdb.com/name/'}${pD.imdb_id}`) : null;
		person['fb'] = (pD.facebook_id != null) ? ('https://www.facebook.com/' + pD.facebook_id) : null;
		person['ig'] = (pD.instagram_id != null) ? ('https://www.instagram.com/' + pD.instagram_id) : null;
		person['twitter'] = (pD.twitter_id != null) ? ('https://www.twitter.com/' + pD.twitter_id) : null;

		res.send(person);
	}))
	.catch( error => {console.log(error)})
});


/* ------------------
	REVIEWS ROUTE
   ------------------ */
app.get('/reviews/:type/:id', function (req, res)
{
	var URL = `${mainURL}${'/'}${req.params.type}${'/'}${req.params.id}${'/reviews'}${apiKey}${lang}${page}`;

	let reviews = [];
	axios.get(URL)
	.then (response =>
	{
		revs = response.data.results;
		for (r of revs)
		{
			if (reviews.length == 3)
				break;
			review = {};
			review['author'] = (r.author != null) ? r.author : "Anonymous"; 
			review['content'] = (r.content != null) ? r.content : "No review recorded...";
			review['date'] = (r.created_at != null) ? calcDate(r.created_at) : 0;
			review['url'] = (r.url != null) ? r.url : "";
			review['rating'] = (r.author_details.rating) ? ((r.author_details.rating)/10*5).toFixed(1) : "0";
			if (r.author_details.avatar_path)
				 if (r.author_details.avatar_path.includes('https://'))
				 	review['avatar'] = r.author_details.avatar_path.substring(1);
				 else
				 	review['avatar'] = 'https://image.tmdb.org/t/p/original' + r.author_details.avatar_path;
			else
				review['avatar'] = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHnPmUvFLjjmoYWAbLTEmLLIRCPpV_OgxCVA&usqp=CAU';
			reviews.push(review);
		}
		res.send(reviews);
	})
	.catch( error => {console.log(error)})
});

/* ------------------
  RECOMMENDATIONS ROUTE
   ------------------ */
   app.get('/individual/:type/:id/:topic', function (req, res)
   {
	   var URL = `${mainURL}${'/'}${req.params.type}${'/'}${req.params.id}${'/'}${req.params.topic}${apiKey}${lang}${page}`;

	   let media = [];
	   axios.get(URL)
	   .then (response =>
	   {
		   result = response.data.results;
		   for (r of result)
		   {
			   curr = {};
			   curr['id'] = r.id;
			   if (r.id == null)
			   		continue;

			   if (req.params.type == 'tv')
			   		curr['title'] = (r.name != null) ? r.name : "No Title Found";
			   else
			   		curr['title'] = (r.title != null) ? r.title : "No Title Found";

			   curr['poster'] = (r.poster_path != null) ? ('https://image.tmdb.org/t/p/w500' + r.poster_path) : 'https://uscfilms.ue.r.appspot.com/assets/movie_placeholder.png';
			   curr['mediaType'] = req.params.type;
			   media.push(curr);
		   }
		   res.send(media);
	   })
	   .catch( error => {console.log(error)})
   });

// Used to parse typeahead results
function parseReslts(m)
{
	var output = {};
	var mediaType = m.media_type;
	output['mediaType'] = mediaType;
	output['poster'] = (m.backdrop_path != null) ? ('https://www.themoviedb.org/t/p/w780' + m.backdrop_path) : "None";
	output['id'] = m.id.toString();
    output["rating"] = (m.vote_average != null) ? ((m.vote_average)/10*5).toFixed(1) : "0.0";

	if (mediaType == "tv")
    {
        output['date'] = (m.first_air_date != null) ? m.first_air_date : "3035";
		output['title'] = (m.name != null) ? m.name : "No Title Found";
    }
    else if (mediaType == "movie")
    {
        output['date'] = (m.release_date != null) ? m.release_date : "3035";
		output['title'] = (m.title != null) ? m.title : "No Title Found";
    }
	return output;
}

// Retrieve genres from TMBD and manipulate the genre IDs to produce a string
function getGenres(genreIDs)
{
	var genreNames = [];
	for (g of genreIDs)
		genreNames.push(g.name);
	return genreNames;
}

// Retrieve genres from TMBD and manipulate the genre IDs to produce a string
function getLanguages(langData)
{
	var languages = [];
	for (l of langData)
		languages.push(l.english_name);
	return languages;
}

//This function takes our ISO date string and converts it to a pretty date string for our review
function calcDate(ugly_date)
{
	obj= new Date(ugly_date);
	options = {month: 'long', day: 'numeric', year: 'numeric'};
	prettyDate = (new Intl.DateTimeFormat('en-US', options).format(obj));
	return (prettyDate);
}

app.use('/assets/:pic', function(req, res)
{
    res.sendFile(path.join(__dirname + '/assets/' + req.params.pic));
});
                                                   
app.use('/*', function(req, res) 
{
	res.sendFile(path.join(__dirname + 'dist/HW8AngApp/index.html'));
});

app.listen(8080, function()
{
	console.log("Backend Sever Up on!");
});

module.exports = app;


