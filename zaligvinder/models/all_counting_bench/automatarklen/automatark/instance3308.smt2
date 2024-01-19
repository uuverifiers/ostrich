(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^GET \/\w+\/\d{5}\/[a-z]{4}\.php\?[a-z]{3}\x5Fid=[A-Za-z0-9+\/]{43}= HTTP\//
(assert (str.in_re X (re.++ (str.to_re "/GET /") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "a" "z")) (str.to_re ".php?") ((_ re.loop 3 3) (re.range "a" "z")) (str.to_re "_id=") ((_ re.loop 43 43) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) (str.to_re "= HTTP//\u{0a}"))))
; WebConnLibNETObserveUser-Agent\x3Ahave100013Agentsvr\x5E\x5EMerlin
(assert (str.in_re X (str.to_re "WebConnLibNETObserveUser-Agent:have100013Agentsvr^^Merlin\u{13}\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
