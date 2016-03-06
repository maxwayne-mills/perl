<?xml version="1.0" encoding="UTF-8"?>
<!--
  sitemap_gen.py example configuration script

  This file specifies a set of sample input parameters for the
  sitemap_gen.py client.

  You should copy this file into "config.xml" and modify it for
  your server.


  ********************************************************* -->


<!-- ** MODIFY **
  The "site" node describes your basic web site.

  Required attributes:
    base_url   - the top-level URL of the site being mapped
    store_into - the webserver path to the desired output file.
                 This should end in '.xml' or '.xml.gz'
                 (the script will create this file)

  Optional attributes:
    verbose    - an integer from 0 (quiet) to 3 (noisy) for
                 how much diagnostic output the script gives
    suppress_search_engine_notify="1"
               - disables notifying search engines about the new map
                 (same as the "testing" command-line argument.)
    default_encoding
               - names a character encoding to use for URLs and
                 file paths.  (Example: "UTF-8")
    sitemap_type
               - declares the Sitemap type,  Common values are
                 web, mobile and news.  'web" Sitemap is default. 
                 (Example: sitemap_type="news")
 <site
  base_url="http://www.fixyourip.com/"
  store_into="/var/www/html/fixyourip/sitemap.xml"
  verbose="1"
  sitemap_type="web"
 
 <!--
 <site
  base_url="http://www.fixyourip.com/"
  store_into="/var/www/html/fixyourip/sitemap.xml"
  verbose="2"
  sitemap_type="web"
 >
 
 -->
 

  <!-- ********************************************************
          INPUTS

  All the various nodes in this section control where the script
  looks to find URLs.

  MODIFY or DELETE these entries as appropriate for your server.
  ********************************************************* -->

  <!-- ** MODIFY or DELETE **
    "url" nodes specify individual URLs to include in the map.

    Required attributes:
      href       - the URL

    Optional attributes:
      lastmod    - timestamp of last modification (ISO8601 format)
      changefreq - how often content at this URL is usually updated
      priority   - value 0.0 to 1.0 of relative importance in your site
  -->

<!--
  <url  href="http://www.example.com/stats?q=name"  />
  <url
     href="http://www.example.com/stats?q=age"
     lastmod="2004-11-14T01:00:00-07:00"
     changefreq="yearly"
     priority="0.3"
  />
-->


  <!-- ** MODIFY or DELETE **
    "urllist" nodes name text files with lists of URLs.
    An example file "example_urllist.txt" is provided.

    Required attribute for all Sitemap types:
      path       - path to the file
    
    Required attribute for News Sitemaps
      tag_order  - News Sitemaps metatag order, comma-separated.
      			   (Example: tag_order="loc, changefreq, lastmod, 
      			   publication_date, keywords")   

    Optional attributes:
      encoding   - encoding of the file if not US-ASCII
                     
  -->
  
<!--
  <urllist 
    path="news_input.txt" 
    encoding="UTF-8"
    tag_order="loc, changefreq, priority, lastmod, publication_date, \
               keywords, stock_tickers"
   />
   
  <urllist path="web_urls.txt" encoding="UTF-8" /> 
-->

  <!-- ** MODIFY or DELETE **
    "directory" nodes tell the script to walk the file system
    and include all files and directories in the Sitemap.

    Required attributes:
      path       - path to begin walking from
      url        - URL equivalent of that path

    Optional attributes:
      default_file - name of the index or default file for directory URLs
      remove_empty_directories - Values are true or false.  Default is false.
      						     true=remove empty directories
  -->

<!--
  <directory  path="/var/www/html/fixyourip"    url="http://www.fixyourip.com/" />
  <directory
     path="/var/www/html/fixyourip/"
     url="http://www.fixyourip.com/"
     default_file="index.php"
     remove_empty_directories="true"
  />
-->
  
  <!--
  "accesslog" nodes tell the script to scan webserver log files to
    extract URLs on your site.  Both Common Logfile Format (Apache's default
    logfile) and Extended Logfile Format (IIS's default logfile) can be read.

    Required attributes:
      path       - path to the file

    Optional attributes:
      encoding   - encoding of the file if not US-ASCII
  -->
  
<!--
  <accesslog  path="/etc/httpd/logs/access.log"       encoding="UTF-8"  />
  <accesslog  path="/etc/httpd/logs/access.log.0"     encoding="UTF-8"  />
  <accesslog  path="/etc/httpd/logs/access.log.1.gz"  encoding="UTF-8"  />
-->
  

  <!-- ********************************************************
          FILTERS

  Filters specify wild-card patterns that the script compares
  against all URLs it finds.  Filters can be used to exclude
  certain URLs from your Sitemap, for instance if you have
  hidden content that you hope the search engines don't find.

  Filters can be either type="wildcard", which means standard
  path wildcards (* and ?) are used to compare against URLs,
  or type="regexp", which means regular expressions are used
  to compare.

  Filters are applied in the order specified in this file.

  An action="drop" filter causes exclusion of matching URLs.
  An action="pass" filter causes inclusion of matching URLs,
  shortcutting any other later filters that might also match.
  If no filter at all matches a URL, the URL will be included.
  Together you can build up fairly complex rules.

  The default action is "drop".
  The default type is "wildcard".

  You can MODIFY or DELETE these entries as appropriate for
  your site.  However, unlike above, the example entries in
  this section are not contrived and may be useful to you as
  they are.
  ********************************************************* -->

  <!-- Exclude URLs that end with a '~'   (IE: emacs backup files)      -->
  <filter  action="drop"  type="wildcard"  pattern="*~"           />

  <!-- Exclude URLs within UNIX-style hidden files or directories       -->
  <filter action="drop" type="regexp"   pattern="/\.[^/]*"     />
  <filter action="drop" type="wildcard" pattern="*icons*" />
  <filter action="drop" type="wildcard" pattern="*logos*" />
  <filter action="drop" type="wildcard" pattern="*todo*" />
  <filter action="drop" type="wildcard" pattern="*Easter*" />
  <filter action="drop" type="wildcard" pattern="*/help/help/*" />
  <filter action="drop" type="wildcard" pattern="*/press/*.gif" />
  
</site>
