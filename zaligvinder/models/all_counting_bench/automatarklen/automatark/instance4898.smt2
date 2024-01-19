(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AWordmyway\.comhoroscope2Host
(assert (not (str.in_re X (str.to_re "Host:Wordmyway.comhoroscope2Host\u{0a}"))))
; (\d{1,3}[\.]\d*)[, ]+-?(\d{1,3}[\.]\d*)
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re ",") (str.to_re " "))) (re.opt (str.to_re "-")) (str.to_re "\u{0a}") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9"))))))
; <textarea(.|\n)*?>((.|\n)*?)</textarea>
(assert (not (str.in_re X (re.++ (str.to_re "<textarea") (re.* (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re ">") (re.* (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re "</textarea>\u{0a}")))))
; ^(\d){7,8}$
(assert (str.in_re X (re.++ ((_ re.loop 7 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; www\x2Eweepee\x2Ecom\w+Owner\x3A\d+metaresults\.copernic\.com
(assert (not (str.in_re X (re.++ (str.to_re "www.weepee.com\u{1b}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:") (re.+ (re.range "0" "9")) (str.to_re "metaresults.copernic.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
