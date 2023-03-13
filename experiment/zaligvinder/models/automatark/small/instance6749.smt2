(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9]{1}[\d]{0,2}(\,[\d]{3})*(\,[\d]{0,2})?|[0-9]{1}[\d]{0,}(\,[\d]{0,2})?|0(\,[\d]{0,2})?|(\,[\d]{1,2})?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ",") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ",") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re ",") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.opt (re.++ (str.to_re ",") ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; /^(\u{00}\u{00}\u{00}\u{00}|.{4}(\u{00}\u{00}\u{00}\u{00}|.{12}))/s
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{00}\u{00}\u{00}\u{00}") (re.++ ((_ re.loop 4 4) re.allchar) (re.union (str.to_re "\u{00}\u{00}\u{00}\u{00}") ((_ re.loop 12 12) re.allchar)))) (str.to_re "/s\u{0a}")))))
; /Accept\u{3a}\u{20}text\/\*\u{2c}\u{20}application\/\*\u{0d}\u{0a}User-Agent\u{3a}\u{20}[^\n]+\u{0d}\u{0a}Host\u{3a}[^\n]+\u{0d}\u{0a}(Pragma|Cache-Control)\u{3a}\u{20}no-cache\u{0d}\u{0a}(Connection\u{3a} Keep-Alive\u{0d}\u{0a})?(\u{0d}\u{0a})?$/
(assert (not (str.in_re X (re.++ (str.to_re "/Accept: text/*, application/*\u{0d}\u{0a}User-Agent: ") (re.+ (re.comp (str.to_re "\u{0a}"))) (str.to_re "\u{0d}\u{0a}Host:") (re.+ (re.comp (str.to_re "\u{0a}"))) (str.to_re "\u{0d}\u{0a}") (re.union (str.to_re "Pragma") (str.to_re "Cache-Control")) (str.to_re ": no-cache\u{0d}\u{0a}") (re.opt (str.to_re "Connection: Keep-Alive\u{0d}\u{0a}")) (re.opt (str.to_re "\u{0d}\u{0a}")) (str.to_re "/\u{0a}")))))
; ad\x2Emokead\x2Ecom\d+Spy\d+ZOMBIES\u{5f}HTTP\u{5f}GETearch\x2Eearthlinkwww\x2Epurityscan\x2EcomUser-Agent\u{3a}
(assert (str.in_re X (re.++ (str.to_re "ad.mokead.com") (re.+ (re.range "0" "9")) (str.to_re "Spy") (re.+ (re.range "0" "9")) (str.to_re "ZOMBIES_HTTP_GETearch.earthlinkwww.purityscan.comUser-Agent:\u{0a}"))))
(check-sat)
