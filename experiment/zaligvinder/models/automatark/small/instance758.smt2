(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((http|https|ftp):\/\/(www\.)?|www\.)[a-zA-Z0-9\_\-]+\.([a-zA-Z]{2,4}|[a-zA-Z]{2}\.[a-zA-Z]{2})(\/[a-zA-Z0-9\-\._\?\&=,'\+%\$#~]*)*$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "http") (str.to_re "https") (str.to_re "ftp")) (str.to_re "://") (re.opt (str.to_re "www."))) (str.to_re "www.")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") (re.union ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.* (re.++ (str.to_re "/") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "?") (str.to_re "&") (str.to_re "=") (str.to_re ",") (str.to_re "'") (str.to_re "+") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "~"))))) (str.to_re "\u{0a}"))))
; Host\x3AUser-Agent\x3Awww\.raxsearch\.com
(assert (not (str.in_re X (str.to_re "Host:User-Agent:www.raxsearch.com\u{0a}"))))
; ([\r\n ]*//[^\r\n]*)+
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " "))) (str.to_re "//") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))))) (str.to_re "\u{0a}")))))
; (\w(\s)?)+
(assert (str.in_re X (re.++ (re.+ (re.++ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "\u{0a}"))))
; eveocczmthmmq\u{2f}omzl\d\x2Fasp\x2Foffers\.asp\?
(assert (str.in_re X (re.++ (str.to_re "eveocczmthmmq/omzl") (re.range "0" "9") (str.to_re "/asp/offers.asp?\u{0a}"))))
(check-sat)
