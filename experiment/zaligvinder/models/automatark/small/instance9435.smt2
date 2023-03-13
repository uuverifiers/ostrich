(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9]{2})(00[1-9]|0[1-9][0-9]|[1-2][0-9][0-9]|3[0-5][0-9]|36[0-6])$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.++ (str.to_re "00") (re.range "1" "9")) (re.++ (str.to_re "0") (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "5") (re.range "0" "9")) (re.++ (str.to_re "36") (re.range "0" "6"))) (str.to_re "\u{0a}")))))
; traffbest\x2Ebiz\d+\.compress.*sidebar\.activeshopper\.comaresflashdownloader\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "traffbest.biz") (re.+ (re.range "0" "9")) (str.to_re ".compress") (re.* re.allchar) (str.to_re "sidebar.activeshopper.comaresflashdownloader.com\u{0a}"))))
; Prodaosearch\x2EcomReferer\x3A007User-Agent\x3A
(assert (not (str.in_re X (str.to_re "Prodaosearch.comReferer:007User-Agent:\u{0a}"))))
; (((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp)://)|(www\.))+(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(/[a-zA-Z0-9\&%_\./-~-]*)?
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.++ (re.union (str.to_re "file") (str.to_re "gopher") (str.to_re "news") (str.to_re "nntp") (str.to_re "telnet") (str.to_re "http") (str.to_re "ftp") (str.to_re "https") (str.to_re "ftps") (str.to_re "sftp")) (str.to_re "://")) (str.to_re "www."))) (re.union (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "&") (str.to_re "%") (str.to_re "_") (str.to_re ".") (re.range "/" "~") (str.to_re "-"))))) (str.to_re "\u{0a}")))))
; to\s+Host\x3AWeHost\u{3a}
(assert (str.in_re X (re.++ (str.to_re "to") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:WeHost:\u{0a}"))))
(check-sat)
