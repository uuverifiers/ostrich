(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[-+]?((\d*|((\d{1,3})?,(\d{3},)*(\d{3})))?)(\.\d*)?([eE][-+]\d+)?$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.opt (re.union (re.* (re.range "0" "9")) (re.++ (re.opt ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.opt (re.++ (str.to_re ".") (re.* (re.range "0" "9")))) (re.opt (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.union (str.to_re "-") (str.to_re "+")) (re.+ (re.range "0" "9")))) (str.to_re "/\u{0a}")))))
; /filename=[^\n]*\u{2e}csd/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".csd/i\u{0a}")))))
; ^([1-9]+\d{0,2},(\d{3},)*\d{3}(\.\d{1,2})?|[1-9]+\d*(\.\d{1,2})?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.+ (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; news\d+Host\x3A\d+Spywww\x2Eemp3finder\x2Ecomwwwvbclient\x3DSpyBuddyZOMBIES\u{5f}HTTP\u{5f}GETearch\x2Eearthlink
(assert (not (str.in_re X (re.++ (str.to_re "news") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Spywww.emp3finder.comwwwvbclient=SpyBuddyZOMBIES_HTTP_GETearch.earthlink\u{0a}")))))
(check-sat)
