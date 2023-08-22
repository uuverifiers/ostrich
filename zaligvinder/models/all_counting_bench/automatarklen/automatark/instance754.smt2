(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^GET \/\w+\/\d{5}\/[a-z]{4}\.php\?[a-z]{3}\x5Fid=[A-Za-z0-9+\/]{43}= HTTP\//
(assert (str.in_re X (re.++ (str.to_re "/GET /") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "a" "z")) (str.to_re ".php?") ((_ re.loop 3 3) (re.range "a" "z")) (str.to_re "_id=") ((_ re.loop 43 43) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) (str.to_re "= HTTP//\u{0a}"))))
; ^[ \w]{3,}([A-Za-z]\.)?([ \w]*\#\d+)?(\r\n| )[ \w]{3,},\u{20}[A-Za-z]{2}\u{20}\d{5}(-\d{4})?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (str.to_re "."))) (re.opt (re.++ (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "#") (re.+ (re.range "0" "9")))) (re.union (str.to_re "\u{0d}\u{0a}") (str.to_re " ")) (str.to_re ", ") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re " ") ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 3 3) (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
; /nsrmm[^\u{00}]*?([\u{3b}\u{7c}\u{26}\u{60}]|\u{24}\u{28})/
(assert (not (str.in_re X (re.++ (str.to_re "/nsrmm") (re.* (re.comp (str.to_re "\u{00}"))) (re.union (str.to_re "$(") (str.to_re ";") (str.to_re "|") (str.to_re "&") (str.to_re "`")) (str.to_re "/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
