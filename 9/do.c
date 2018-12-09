#include <stdio.h>
#include <stdlib.h>

unsigned long max = 24;
unsigned long players = 9;

typedef struct node {
    struct node *next;
    struct node *prev;
    unsigned long value;
} node_t;

void insert_after() {

}

int main(void) {

    unsigned long marble = 1;
    node_t *current;

    node_t *ring = malloc(max * sizeof(node_t));

    ring[0].value = 0;
    ring[0].next = &ring[0];
    ring[0].prev = &ring[0];
    current = &ring[0];

    while (marble < max) {
        node_t new = {.prev = current->next, .next = current->next->next, .value = marble};
        ring[marble] = new;
        current->next->next->prev = &ring[marble];
        current->next->next = &ring[marble];

        current = &ring[marble];
        marble += 1;
    }

    for (int i=0; i<max; i++)
        printf("%lu ", ring[i].value);
    printf("\n");


    node_t *p = &ring[0];
    for (int i=0; i<max; i++) {
        printf("%lu ", p->value);
        p = p->next;
    }
    printf("\n");
}
