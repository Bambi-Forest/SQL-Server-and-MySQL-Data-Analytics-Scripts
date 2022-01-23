/*
Finding Top Travel Sources

Problem: 
	NEW MESSAGE
    April 12, 2012
    From: Cindy Sharp (CEO)
    Subject: Site traffic breakdown
		Good morning,
		We've been live for almost a month now and we’re
		starting to generate sales. Can you help me understand
		where the bulk of our website sessions are coming
		from, through yesterday?
		I’d like to see a breakdown by UTM source, campaign
		and referring domain if possible. Thanks!
		-Cindy
*/

SELECT 
	web_sess.utm_source,
    web_sess.utm_campaign,
    web_sess.http_referer AS domain_referer,
    COUNT(DISTINCT web_sess.website_session_id) AS sessions
FROM website_sessions web_sess
	LEFT JOIN website_pageviews web_page
		ON web_sess.website_session_id = web_page.website_session_id
WHERE web_page.created_at < '2012-04-12'
GROUP BY 
	web_sess.utm_source,
	web_sess.utm_campaign,
    web_sess.http_referer		
ORDER BY sessions DESC;

/*
Solution:
  From: Nage Murphy (Junior Data Analysis)
  Subject: RE: Site traffic breakdown
  
  Good evening Cindy,

  Based off our analaysis with results before April 12, 2012 indicates that we should be focusing on 
  gsearch utm_source that are nonbrand compaigns paid traffic to gain further insights due to having the most number of sessions. 
  
  Best,
  Nage
  
*/

/*
Response:
		NEW MESSAGE
		From: Cindy Sharp (CEO)
		Subject: RE: Site traffic breakdown
		April 12, 2012
		Great analysis!
		Based on your findings, it seems like we should 
		probably dig into gsearch nonbrand a bit deeper to 
		see what we can do to optimize there.
		I’ll loop in Tom tomorrow morning to get his thoughts 
		on next steps.
			   -Cindy
*/


/*
Problem:
		NEW MESSAGE 
		From: Tom Parmesan (Marketing Director)
		Subject: Gsearch conversion rate
		April 14, 2012
				Hi there,
				Sounds like gsearch nonbrand is our major traffic source, but 
				we need to understand if those sessions are driving sales.
				Could you please calculate the conversion rate (CVR) from 
				session to order? Based on what we're paying for clicks, 
				we’ll need a CVR of at least 4% to make the numbers work. 
				If we're much lower, we’ll need to reduce bids. If we’re 
				higher, we can increase bids to drive more volume.
				Thanks, Tom

*/
 
 SELECT 
     COUNT(DISTINCT web_sess.website_session_id) AS sessions,
     COUNT(DISTINCT orders.order_id) AS orders,
	 COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT web_sess.website_session_id)  AS session_to_order_conversion_rate
FROM 
	website_sessions web_sess
	LEFT JOIN orders orders
		ON web_sess.website_session_id = orders.website_session_id
WHERE web_sess.created_at < '2012-04-14'
	AND (web_sess.utm_source = 'gsearch'
    AND web_sess.utm_campaign = 'nonbrand');
    
/*
Solution:
	NEW MESSAGE 
		From: Nage Murphy (Junior Data Analyst)
		Subject: Gsearch conversion rate Analysis
		April 14, 2012
        
        Good evening Tom,
        
        Based on the analysis gsearch nonbrand has a converstion rate of 0.0288% which we may need to reduce bids
        due to the number of orders to sessions.
        
        Best,
        Nage
    
*/

/*
  Response:
		NEW MESSAGE
		From: Tom Parmesan (Marketing Director)
		Subject: RE: Gsearch conversion rate 
		April 14, 2012
			Hmm, looks like we’re below the 4% threshold we need 
			to make the economics work. 
			Based on this analysis, we’ll need to dial down our 
			search bids a bit. We're over-spending based on the 
			current conversion rate. 
			Nice work, your analysis just saved us some $$$!
            -Tom
*/


    
    
/*
TRAFFIC SOURCE BID OPTIMIZATION


Problem:
	NEW MESSAGE 
		From: Tom Parmesan (Marketing Director)
		Subject: Gsearch volume trends
		May 12, 2012
		Hi there,
		Based on your conversion rate analysis, we bid down 
		gsearch nonbrand on 2012-04-15. 
		Can you pull gsearch nonbrand trended session volume, by 
		week, to see if the bid changes have caused volume to drop 
		at all?
		Thanks, Tom

*/

SELECT 
    DATE(web_sess.created_at) AS week_start_date,
	COUNT(DISTINCT CASE WHEN web_sess.utm_source = 'gsearch' AND web_sess.utm_campaign = 'nonbrand'  THEN website_session_id ELSE NULL END )AS Total_sessions
FROM website_sessions web_sess
WHERE web_sess.created_at < '2012-05-10'
GROUP BY YEARWEEK(web_sess.created_at)  ;  
     
/*
Solution:
	Solution:
  From: Nage Murphy (Junior Data Analysis)
  Subject: RE:  Gsearch volume trends
  May 10, 2012
  
  Good evening Tom,

  Here is the Total number number of sesions from gsearch nonbrand per week. Based off the analysis, it looks like our number of sessions are sensitive after the bid down on 4-15-12. 
  The number of sesions gradually begins to decrease.
  
  Best,
  Nage
*/

/*
Response:
		NEW MESSAGE
		From: Tom Parmesan (Marketing Director)
		Subject: RE: Gsearch volume trends
		May 10, 2012
		TEST YOUR SKILLS: TRAFFIC SOURCE TRENDING

		Hi there, great analysis! 
		Okay, based on this, it does look like gsearch nonbrand is 
		fairly sensitive to bid changes. 
		We want maximum volume, but don’t want to spend more 
		on ads than we can afford.
		Let me think on this. I will likely follow up with some ideas.
		Thanks, Tom
*/


/*
Problem:
		NEW MESSAGE 
		From: Tom Parmesan (Marketing Director)
		Subject: Gsearch device-level performance
		May 11, 2012
		Hi there,
		I was trying to use our site on my mobile device the other 
		day, and the experience was not great. 
		Could you pull conversion rates from session to order, by 
		device type? 
		If desktop performance is better than on mobile we may be 
		able to bid up for desktop specifically to get more volume?
		Thanks, Tom

*/


SELECT 
    web_sess.device_type,
	COUNT(DISTINCT web_sess.website_session_id ) AS Total_Sessions,
    COUNT(DISTINCT orders.order_id) AS Orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT web_sess.website_session_id) AS session_to_order_conv_rate
FROM website_sessions web_sess
	LEFT JOIN orders orders
		ON web_sess.website_session_id = orders.website_session_id
WHERE 
    web_sess.created_at < '2012-05-11' AND
	web_sess.utm_source = 'gsearch' AND 
    web_sess.utm_campaign = 'nonbrand'
GROUP BY web_sess.device_type;


/*
Solution:
	NEW MESSAGE 
		From: Nage Murphy (Junior Data Analyst)
		Subject: Gsearch device-level performance
		May 11, 2012
		Hi Tom,
        
        Based on the analyses for convrsion rates of mobile vs desktop. Desktop has a higher session to order conversion rate of 0.0373. 
        Mobile has a conversion rate of 0.00096. So you can bid higher on dessktop to possible draw in more volume.
        
        -Nage
        
*/

/*
Response:
		NEW MESSAGE
		From: Tom Parmesan (Marketing Director)
		Subject: RE: Gsearch device-level performance
		May 11, 2012

		Great! 
		I'm going to increase our bids on desktop. 
		When we bid higher, we’ll rank higher in the auctions, so I 
		think your insights here should lead to a sales boost. 
		Well done!!
		-Tom

*/


/*
Problem:
		NEW MESSAGE 
		From: Tom Parmesan (Marketing Director)
		Subject: Gsearch device-level trends
		June 09, 2012
		Hi there,
		After your device-level analysis of conversion rates, we 
		realized desktop was doing well, so we bid our gsearch 
		nonbrand desktop campaigns up on 2012-05-19. 
		Could you pull weekly trends for both desktop and mobile 
		so we can see the impact on volume? 
		You can use 2012-04-15 until the bid change as a baseline.
		Thanks, Tom

*/

SELECT 
	DATE(web_sess.created_at) AS start_date, 
    COUNT(DISTINCT CASE WHEN web_sess.device_type = 'mobile' THEN web_sess.website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN web_sess.device_type = 'desktop' THEN web_sess.website_session_id ELSE NULL END) AS desktop_sessions
FROM website_sessions web_sess
WHERE
	web_sess.created_at BETWEEN '2012-04-15' AND '2012-06-09'
    AND web_sess.utm_source = 'gsearch'
    AND web_sess.utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(web_sess.created_at);


/*
Solution:
	NEW MESSAGE 
		From: Nage Murphy (Junior Data Analyst)
		Subject: Gsearch device-level performance
		June 09, 2012
		Hi Tom,
        
        Based on the analyses for optimizing the desktop bids. After bidding up on 2012-05-19, we can see a gradual increase in volume for desktops and mobile is steadily decreasing.
        May want to keep a eye on the volume in the upcoming months for further investigation. 
        
        
        -Nage
        
*/

/*
NEW MESSAGE
From: Tom Parmesan (Marketing Director)
Subject: RE: Gsearch device-level trends
June 09, 2012
TEST YOUR SKILLS: TRAFFIC SOURCE SEGMENT TRENDING

Nice work digging into this! 
It looks like mobile has been pretty flat or a little down, but 
desktop is looking strong thanks to the bid changes we 
made based on your previous conversion analysis. 
Things are moving in the right direction!
Thanks, Tom

In concluion of our Analysis:
	NEXT STEPS:
	• Continue to monitor device-level volume and be 
	aware of the impact bid levels has
	• Continue to monitor conversion performance at 
	the device-level to optimize spend
*/