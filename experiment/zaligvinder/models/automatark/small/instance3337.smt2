(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp)://)|(www\.))+(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(/[a-zA-Z0-9\&%_\./-~-]*)?
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.++ (re.union (str.to_re "file") (str.to_re "gopher") (str.to_re "news") (str.to_re "nntp") (str.to_re "telnet") (str.to_re "http") (str.to_re "ftp") (str.to_re "https") (str.to_re "ftps") (str.to_re "sftp")) (str.to_re "://")) (str.to_re "www."))) (re.union (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "&") (str.to_re "%") (str.to_re "_") (str.to_re ".") (re.range "/" "~") (str.to_re "-"))))) (str.to_re "\u{0a}")))))
; GmbH\d+Host\x3A\w+adblock\x2Elinkz\x2EcomUser-Agent\x3Aemail
(assert (str.in_re X (re.++ (str.to_re "GmbH") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "adblock.linkz.comUser-Agent:email\u{0a}"))))
(check-sat)
