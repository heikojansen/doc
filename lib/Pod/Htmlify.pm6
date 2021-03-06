module Pod::Htmlify;

use URI::Escape;

sub url-munge($_) is export {
    return $_ if m{^ <[a..z]>+ '://'};
    return "/type/{uri_escape $_}" if m/^<[A..Z]>/;
    return "/routine/{uri_escape $_}" if m/^<[a..z]>|^<-alpha>*$/;
    # poor man's <identifier>
    if m/ ^ '&'( \w <[[\w'-]>* ) $/ {
        return "/routine/{uri_escape $0}";
    }
    return $_;
}

sub footer-html($pod-path) is export {
    my $footer = slurp 'template/footer.html';
    $footer.subst-mutate(/DATETIME/, ~DateTime.now);
    my $pod-url;
    if $pod-path eq "unknown" {
        $pod-url = "the sources at <a href='https://github.com/perl6/doc'>perl6/doc on GitHub</a>";
    }
    else {
        $pod-url = "<a href='https://github.com/perl6/doc/raw/master/lib/$pod-path'>$pod-path\</a\>";
    }
    $footer.subst-mutate(/SOURCEURL/, $pod-url);

    return $footer;
}

# vim: expandtab shiftwidth=4 ft=perl6
