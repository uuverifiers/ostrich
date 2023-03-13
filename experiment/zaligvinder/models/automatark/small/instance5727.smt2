(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3Aas\x2Estarware\x2Ecom\x2Fdp\x2Fsearch\?x=
(assert (str.in_re X (str.to_re "Host:as.starware.com/dp/search?x=\u{0a}")))
; (((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp)://)|(www\.))+(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(/[a-zA-Z0-9\&%_\./-~-]*)?
(assert (str.in_re X (re.++ (re.+ (re.union (re.++ (re.union (str.to_re "file") (str.to_re "gopher") (str.to_re "news") (str.to_re "nntp") (str.to_re "telnet") (str.to_re "http") (str.to_re "ftp") (str.to_re "https") (str.to_re "ftps") (str.to_re "sftp")) (str.to_re "://")) (str.to_re "www."))) (re.union (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "&") (str.to_re "%") (str.to_re "_") (str.to_re ".") (re.range "/" "~") (str.to_re "-"))))) (str.to_re "\u{0a}"))))
; /\u{2e}docm([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.docm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; User-Agent\x3Auuid=aadserverfowclxccdxn\u{2f}uxwn\.ddy
(assert (not (str.in_re X (str.to_re "User-Agent:uuid=aadserverfowclxccdxn/uxwn.ddy\u{0a}"))))
(check-sat)
