#include <stdio.h>
#include <stdlib.h>

unsigned long max = 25;
unsigned long players = 9;

typedef struct node {
    struct node *next;
    struct node *prev;
    unsigned long value;
} node_t;

void insert_after() {

}

void draw(node_t *ring, node_t *current) {
    node_t *p = &ring[0];
    for (int i=0; i<max; i++) {
        if (p == current)
            printf("(%lu)", p->value);
        else
            printf(" %lu ", p->value);
        p = p->next;
        if (p == &ring[0])
            break;
    }
    printf("\n");
}

int main(void) {
    #if 1
    max = 72164;
    players = 419;
    #define NODRAW
    #endif

    unsigned long marble = 1;
    int player = 0;
    node_t *current;

    node_t *ring = malloc((max + 1) * sizeof(node_t));
    unsigned long *scores = calloc(players, sizeof(unsigned long));

    ring[0].value = 0;
    ring[0].next = &ring[0];
    ring[0].prev = &ring[0];
    current = &ring[0];

    while (marble < max) {
        if (marble % 23 == 0) {
            node_t *p = current;
            for (int i = 0; i < 7; i++)
                p = p->prev;
            scores[player] += p->value;
            p->next->prev = p->prev;
            p->prev->next = p->next;
            scores[player] += marble;
            current = p->next;
        } else {
            node_t new = {.prev = current->next, .next = current->next->next, .value = marble};
            ring[marble] = new;
            current->next->next->prev = &ring[marble];
            current->next->next = &ring[marble];
            current = &ring[marble];
        }

#ifndef NODRAW
        draw(ring, current);
#endif

        marble += 1;
        player = (player + 1) % players;
    }

#ifndef NODRAW
    draw(ring, current);
#endif

    unsigned long max_score = 0;
    for (int i=0; i<players; i++) {
        printf("[%d] %lu\n", i, scores[i]);
        if (scores[i] > max_score)
            max_score = scores[i];
    }
    printf("higest score: %lu\n", max_score);
}
