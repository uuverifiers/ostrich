(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /bbdd(host|user|passwd)=\u{22}[^\s]*?([\u{60}\u{3b}\u{7c}]|\u{24}\u{28})/i
(assert (str.in_re X (re.++ (str.to_re "/bbdd") (re.union (str.to_re "host") (str.to_re "user") (str.to_re "passwd")) (str.to_re "=\u{22}") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "$(") (str.to_re "`") (str.to_re ";") (str.to_re "|")) (str.to_re "/i\u{0a}"))))
; /^[a-z]\x3D[0-9a-z]{100}$/Pm
(assert (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 100 100) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "/Pm\u{0a}"))))
; Host\x3ASubject\x3AFrom\u{3a}\u{d0}\u{c5}\u{cf}\u{a2}
(assert (str.in_re X (str.to_re "Host:Subject:From:\u{d0}\u{c5}\u{cf}\u{a2}\u{0a}")))
; (Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|(Nov|Dec)(ember)?)
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "Jan") (re.opt (str.to_re "uary"))) (re.++ (str.to_re "Feb") (re.opt (str.to_re "ruary"))) (re.++ (str.to_re "Mar") (re.opt (str.to_re "ch"))) (re.++ (str.to_re "Apr") (re.opt (str.to_re "il"))) (str.to_re "May") (re.++ (str.to_re "Jun") (re.opt (str.to_re "e"))) (re.++ (str.to_re "Jul") (re.opt (str.to_re "y"))) (re.++ (str.to_re "Aug") (re.opt (str.to_re "ust"))) (re.++ (str.to_re "Sep") (re.opt (str.to_re "tember"))) (re.++ (str.to_re "Oct") (re.opt (str.to_re "ober"))) (re.++ (re.union (str.to_re "Nov") (str.to_re "Dec")) (re.opt (str.to_re "ember")))) (str.to_re "\u{0a}")))))
; [A-Z0-9]{5}\d[0156]\d([0][1-9]|[12]\d|3[01])\d[A-Z0-9]{3}[A-Z]{2}
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.range "0" "9") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "5") (str.to_re "6")) (re.range "0" "9") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.range "0" "9") ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
