(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([(][1-9]{2}[)] )?[0-9]{4}[-]?[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "(") ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re ") "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\xF6\xEC\xD9\xB3\u{67}\xCF\x9E\x3D\x7B(\xF6\xEC\xD9\xB3\u{67}\xCF\x9E\x3D\x7B){500}/m
(assert (str.in_re X (re.++ (str.to_re "/\u{f6}\u{ec}\u{d9}\u{b3}g\u{cf}\u{9e}={") ((_ re.loop 500 500) (str.to_re "\u{f6}\u{ec}\u{d9}\u{b3}g\u{cf}\u{9e}={")) (str.to_re "/m\u{0a}"))))
; www\x2Eeblocs\x2Ecomcorep\x2Edmcast\x2Ecom
(assert (not (str.in_re X (str.to_re "www.eblocs.com\u{1b}corep.dmcast.com\u{0a}"))))
; ^([\(]{1}[0-9]{3}[\)]{1}[ |\-]{0,1}|^[0-9]{3}[\-| ])?[0-9]{3}(\-| ){1}[0-9]{4}(([ ]{0,1})|([ ]{1}[0-9]{3,4}|))$
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ ((_ re.loop 1 1) (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "|") (str.to_re "-")))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re "|") (str.to_re " "))))) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (re.opt (str.to_re " ")) (re.++ ((_ re.loop 1 1) (str.to_re " ")) ((_ re.loop 3 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Host\x3A\u{2c}STATSTimeTotalpassword\x3B1\x3BOptix
(assert (not (str.in_re X (str.to_re "Host:,STATSTimeTotalpassword;1;Optix\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
