(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (.*\.([wW][mM][aA])|([mM][pP][3])$)
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.* re.allchar) (str.to_re ".") (re.union (str.to_re "w") (str.to_re "W")) (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "a") (str.to_re "A"))) (re.++ (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "p") (str.to_re "P")) (str.to_re "3"))) (str.to_re "\u{0a}")))))
; ^(\+)?([9]{1}[2]{1})?-? ?(\()?([0]{1})?[1-9]{2,4}(\))?-? ??(\()?[1-9]{4,7}(\))?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re "9")) ((_ re.loop 1 1) (str.to_re "2")))) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) (re.opt (str.to_re "(")) (re.opt ((_ re.loop 1 1) (str.to_re "0"))) ((_ re.loop 2 4) (re.range "1" "9")) (re.opt (str.to_re ")")) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) (re.opt (str.to_re "(")) ((_ re.loop 4 7) (re.range "1" "9")) (re.opt (str.to_re ")")) (str.to_re "\u{0a}"))))
; /setAttributeNS\s*\u{28}[^,]*,[^,]*requiredFeatures[^,]*,\s*[\u{22}\u{27}][\s\r\n]+[\u{22}\u{27}]/i
(assert (not (str.in_re X (re.++ (str.to_re "/setAttributeNS") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.comp (str.to_re ","))) (str.to_re ",") (re.* (re.comp (str.to_re ","))) (str.to_re "requiredFeatures") (re.* (re.comp (str.to_re ","))) (str.to_re ",") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "/i\u{0a}")))))
; actualnames\.comclient\x2Ebaigoo\x2Ecomzzzvmkituktgr\u{2f}etiexpsp2-InformationHost\x3A
(assert (str.in_re X (str.to_re "actualnames.comclient.baigoo.comzzzvmkituktgr/etiexpsp2-InformationHost:\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
