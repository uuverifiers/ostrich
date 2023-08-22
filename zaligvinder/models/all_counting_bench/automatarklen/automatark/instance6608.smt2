(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; port\s+aresflashdownloader\x2Ecom\s+adfsgecoiwnf\u{23}\u{23}\u{23}\u{23}User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "port") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "aresflashdownloader.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "adfsgecoiwnf\u{1b}####User-Agent:\u{0a}")))))
; (^(30)[0-5]\d{11}$)|(^(36)\d{12}$)|(^(38[0-8])\d{11}$)
(assert (not (str.in_re X (re.union (re.++ (str.to_re "30") (re.range "0" "5") ((_ re.loop 11 11) (re.range "0" "9"))) (re.++ (str.to_re "36") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "38") (re.range "0" "8"))))))
; /^(application|audio|example|image|message|model|multipart|text|video)\/[a-zA-Z0-9]+([+.-][a-zA-z0-9]+)*$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "application") (str.to_re "audio") (str.to_re "example") (str.to_re "image") (str.to_re "message") (str.to_re "model") (str.to_re "multipart") (str.to_re "text") (str.to_re "video")) (str.to_re "/") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.* (re.++ (re.union (str.to_re "+") (str.to_re ".") (str.to_re "-")) (re.+ (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9"))))) (str.to_re "/\u{0a}"))))
; www\x2Eblazefind\x2Ecom.*started\x2E\s+CodeguruBrowserwww\x2Esogou\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "www.blazefind.com") (re.* re.allchar) (str.to_re "started.") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "CodeguruBrowserwww.sogou.com\u{0a}")))))
; searches\x2Eworldtostart\x2Ecom\w+searchreslt\x7D\x7BSysuptime\x3A
(assert (str.in_re X (re.++ (str.to_re "searches.worldtostart.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "searchreslt}{Sysuptime:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
