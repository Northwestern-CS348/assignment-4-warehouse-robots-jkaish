(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action robotMove
	  :parameters (?l1 - location ?l2 - location ?r - robot)
	  :precondition (and (at ?r ?l1) (available ?l2) (connected ?l1 ?l2))
      :effect (and (available ?l1) (not (available ?l2)) (at ?r ?l2) (not (at ?r ?l1)))
      )
      
   (:action robotMoveWithPallette
        :parameters (?l1 - location ?l2 - location ?r - robot ?p - pallette)
        :precondition (and (at ?r ?l1) (available ?l2) (connected ?l1 ?l2) (at ?p ?l1) (has ?r ?p))
        :effect (and (available ?l1) (not (available ?l2)) (at ?r ?l2) (not (at ?r ?l1))
                (at ?p ?l2) (not (at ?p ?l1)))
   )
   
   (:action moveItemFromPalletteToShipment
        :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
        :precondition (and (packing-location ?l) (packing-at ?s ?l) (contains ?p ?si)
                            (ships ?s ?o) (orders ?o ?si) (started ?s))
        :effect (includes ?s ?si)
   )
   
   (:action completeShipment
        :parameters (?s - shipment ?o - order ?l - location)
        :precondition (and (started ?s) (ships ?s ?o))
        :effect (and (not (started ?s)) (complete ?s))
   )
)





